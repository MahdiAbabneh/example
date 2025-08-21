import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'example.dart';

class StandardStyleInteractionsExample extends StatefulWidget
    implements Example {
  @override
  final Widget leading = const Icon(Icons.touch_app);
  @override
  final String title = 'Standard Style Interactions';
  @override
  final String? subtitle = 'Showcase of Standard Style interactions';

  const StandardStyleInteractionsExample({super.key});

  @override
  State<StatefulWidget> createState() => StandardStyleInteractionsState();
}

class StandardStyleInteractionsState
    extends State<StandardStyleInteractionsExample> {
  StandardStyleInteractionsState();
  MapboxMap? mapboxMap;
  FeaturesetFeature? selectedBuilding;

  String buildingHighlightColor = 'hsl(214, 94%, 59%)';

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _updateMapStyle();

    /// When a building in the Standard Buildings featureset is tapped, set that building as highlighted to color it.
    var tapInteractionBuildings =
        TapInteraction(StandardBuildings(), (feature, _) {
      if (selectedBuilding != null) {
        mapboxMap.removeFeatureStateForFeaturesetFeature(
            feature: selectedBuilding!, stateKey: "highlight");
      }
      mapboxMap.setFeatureStateForFeaturesetFeature(
          feature, StandardBuildingsState(highlight: true));
      selectedBuilding = feature;
    });
    mapboxMap.addInteraction(tapInteractionBuildings);

    // Long-tap anywhere to clear building highlights
    var longTapInteraction = LongTapInteraction.onMap((_) {
      mapboxMap.resetFeatureStatesForFeatureset(StandardBuildings());
      selectedBuilding = null;
    });
    mapboxMap.addInteraction(longTapInteraction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapWidget(
      key: ValueKey("mapWidget"),
      cameraOptions: CameraOptions(
        center: Point(coordinates: Position(24.9453, 60.1718)),
        bearing: 49.92,
        zoom: 16.35,
        pitch: 40,
      ),
      styleUri: MapboxStyles.STANDARD,
      textureView: true,
      onMapCreated: _onMapCreated,
    ));
  }

  void _updateMapStyle() {
    // Set the highlight color for selected buildings
    var configs = {
      "colorBuildingHighlight": buildingHighlightColor,
    };
    mapboxMap?.style.setStyleImportConfigProperties("basemap", configs);
  }
}
