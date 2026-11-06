import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class LocationCheckResult {
  final String? ip;
  final String? countryCode;
  final bool isFiltered;
  final bool hasInternet;
  final String? provider;

  const LocationCheckResult({
    this.ip,
    this.countryCode,
    required this.isFiltered,
    required this.hasInternet,
    this.provider,
  });

  bool get isIran => countryCode == 'IR';
  bool get isSafe => hasInternet && !isFiltered;

  @override
  String toString() =>
      'LocationCheckResult(ip: $ip, country: $countryCode, isFiltered: $isFiltered, hasInternet: $hasInternet, provider: $provider)';
}

class NetworkLocationService {
  static const Set<String> filteredCountries = {'IR', 'CN'};

  Future<LocationCheckResult> checkLocation() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);

    // 1. Try api.country.is (very fast & reliable from Iran)
    try {
      final req = await client.getUrl(Uri.parse('https://api.country.is'));
      final res = await req.close().timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final country = data['country']?.toString().toUpperCase() ?? '';
        final ip = data['ip']?.toString();
        client.close();
        final isFiltered = filteredCountries.contains(country);
        debugPrint('[NetworkLocation] api.country.is -> ip: $ip, country: $country, isFiltered: $isFiltered');
        return LocationCheckResult(
          ip: ip,
          countryCode: country,
          isFiltered: isFiltered,
          hasInternet: true,
          provider: 'api.country.is',
        );
      }
    } catch (e) {
      debugPrint('[NetworkLocation] api.country.is failed: $e');
    }

    // 2. Try cloudflare.com/cdn-cgi/trace
    try {
      final req = await client.getUrl(Uri.parse('https://cloudflare.com/cdn-cgi/trace'));
      final res = await req.close().timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        String? loc;
        String? ip;
        for (final line in body.split('\n')) {
          if (line.startsWith('loc=')) {
            loc = line.substring(4).trim().toUpperCase();
          } else if (line.startsWith('ip=')) {
            ip = line.substring(3).trim();
          }
        }
        if (loc != null && loc.isNotEmpty) {
          client.close();
          final isFiltered = filteredCountries.contains(loc);
          debugPrint('[NetworkLocation] cloudflare trace -> ip: $ip, loc: $loc, isFiltered: $isFiltered');
          return LocationCheckResult(
            ip: ip,
            countryCode: loc,
            isFiltered: isFiltered,
            hasInternet: true,
            provider: 'cloudflare',
          );
        }
      }
    } catch (e) {
      debugPrint('[NetworkLocation] cloudflare trace failed: $e');
    }

    // 3. Try ip-api.com
    try {
      final req = await client.getUrl(Uri.parse('http://ip-api.com/json'));
      final res = await req.close().timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = await res.transform(utf8.decoder).join();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final country = data['countryCode']?.toString().toUpperCase() ?? '';
        final ip = data['query']?.toString();
        client.close();
        final isFiltered = filteredCountries.contains(country);
        debugPrint('[NetworkLocation] ip-api -> ip: $ip, country: $country, isFiltered: $isFiltered');
        return LocationCheckResult(
          ip: ip,
          countryCode: country,
          isFiltered: isFiltered,
          hasInternet: true,
          provider: 'ip-api.com',
        );
      }
    } catch (e) {
      debugPrint('[NetworkLocation] ip-api failed: $e');
    }

    client.close();
    return const LocationCheckResult(
      isFiltered: false,
      hasInternet: false,
      provider: 'none',
    );
  }
}
