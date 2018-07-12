L = require 'leaflet'

turf = require '@turf/helpers'
turfDifference = require('@turf/difference')
turfUnion = require('@turf/union').default
turfTruncate = require('@turf/truncate').default
polygonClipping = require("polygon-clipping")

class L.Calculation

  @union: (polygons) ->
    turfFeatures = polygons.map (polygon) ->
      turf.feature(polygon)
    turfFeatures.reduce (poly1, poly2) ->
      turfUnion(poly1, poly2)

  @difference: (feature1, feature2) ->
    p1 = turfTruncate(feature1, precision: 10).geometry
    p2 = turfTruncate(feature2, precision: 10).geometry
    diffCoordinates = polygonClipping.difference(p1.coordinates, p2.coordinates)
    turf.multiPolygon(diffCoordinates)
