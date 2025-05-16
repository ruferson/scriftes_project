import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:skriftes_project_2/themes/color_repository.dart';
import 'package:skriftes_project_2/screens/settings/settings_controller.dart';
import 'package:skriftes_project_2/screens/screen_bar.dart';

class LocationPickerPage extends StatefulWidget {
  final SettingsController controller;

  const LocationPickerPage({super.key, required this.controller});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  LatLng? _selectedPosition;
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;
  bool _isTyping = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onTextChanged(String query) {
    setState(() => _isTyping = true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      _fetchSuggestions(query);
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (query.length < 3) {
      setState(() {
        _suggestions.clear();
        _isSearching = false;
        _isTyping = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5&addressdetails=1',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'skriftes_project_2/1.0'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _suggestions = data.map<Map<String, dynamic>>((item) {
            return {
              'display_name': item['display_name'],
              'lat': double.parse(item['lat']),
              'lon': double.parse(item['lon']),
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error al obtener sugerencias: $e');
    } finally {
      setState(() {
        _isSearching = false;
        _isTyping = false;
      });
    }
  }

  void _onSuggestionTap(Map<String, dynamic> suggestion) {
    final newPosition = LatLng(suggestion['lat'], suggestion['lon']);
    setState(() {
      _selectedPosition = newPosition;
      _suggestions.clear();
      _searchController.text = suggestion['display_name'];
    });
    _mapController.move(newPosition, 15.0);
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _suggestions.clear();
      _selectedPosition = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = widget.controller.themeMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kTextTabBarHeight),
        child: ScriftesScreenBar(
          toolbarHeight: kTextTabBarHeight,
          controller: widget.controller,
          title: 'Selecciona ubicación',
        ),
      ),
      backgroundColor:
          ColorRepository.getColor(ColorName.primaryColor, themeMode),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                hintText: 'Buscar ubicación...',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: _buildSuffixIcon(),
              ),
            ),
          ),
          if (_suggestions.isNotEmpty) _buildSuggestionsList(),
          Expanded(child: _buildMap(themeMode)),
        ],
      ),
      floatingActionButton: _selectedPosition != null
          ? FloatingActionButton(
              onPressed: () async {
                // Convierte LatLng a GeoPoint
                final geoPoint = GeoPoint(
                    _selectedPosition!.latitude, _selectedPosition!.longitude);
                print(geoPoint.toString());
                // Actualiza la ubicación en SettingsController
                await widget.controller.updateUserLocation(geoPoint);
                // Cierra la pantalla y opcionalmente puedes enviar algo o no
                Navigator.pop(context);
              },
              backgroundColor: ColorRepository.getColor(
                ColorName.specialColor,
                themeMode,
              ),
              child: Icon(
                Icons.check,
                color: ColorRepository.getColor(
                  ColorName.white,
                  themeMode,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSuffixIcon() {
    if (_searchController.text.isNotEmpty) {
      return IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch);
    }
    if (_isTyping || _isSearching) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    return const Icon(Icons.search);
  }

  Widget _buildSuggestionsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _suggestions[index];
          return ListTile(
            title: Text(suggestion['display_name']),
            onTap: () => _onSuggestionTap(suggestion),
          );
        },
      ),
    );
  }

  Widget _buildMap(ThemeMode themeMode) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([
            LatLng(40.4168, -3.7038),
            LatLng(40.4300, -3.7000),
          ]),
          padding: const EdgeInsets.all(100),
        ),
        onTap: (tapPosition, point) {
          setState(() {
            _selectedPosition = point;
            _suggestions.clear();
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        if (_selectedPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: _selectedPosition!,
                width: 60,
                height: 60,
                child: Icon(
                  Icons.location_pin,
                  color: ColorRepository.getColor(
                      ColorName.brownTextColor, themeMode),
                  size: 40,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
