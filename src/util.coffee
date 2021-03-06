turf = require '@turf/helpers'
turfFlip = require '@turf/flip'
polylabel = require '@mapbox/polylabel'


L.Polygon.include
  toTurfFeature: ->
    return if @isEmpty() or !@_latlngs

    #I don't use project to avoid adding the layer to map

    multi = !L.LineUtil.isFlat(@_latlngs[0])

    poly = if multi then @_latlngs[0] else @_latlngs

    coords = []

    for ring in poly
      coords.push L.GeoJSON.latLngsToCoords(ring, 0, true, 17)

    turf.polygon(coords)

  outerRingAsTurfLineString: ->

    #I don't use project to avoid adding the layer to map

    multi = !L.LineUtil.isFlat(@_latlngs[0])
    ring0 = if multi then @_latlngs[0][0] else @_latlngs[0]

    coords = L.GeoJSON.latLngsToCoords(ring0, 0, true, 17)
    turf.lineString(coords)

  polylabel: (precision = 0.001) ->
    coords = L.GeoJSON.latLngsToCoords(@_latlngs[0], 0, true)
    coord = polylabel([coords], precision)
    L.latLng(coord[1], coord[0])
#
#Returns a LatLng object as a Turf Feature<Point>
L.LatLng::toTurfFeature = ->
  coords = L.GeoJSON.latLngToCoords @
  turf.point coords

L.Polyline.include
  toTurfFeature: ->
    return if @isEmpty() or !@_latlngs
    coords = L.GeoJSON.latLngsToCoords(@_latlngs, 0, 0, 17)
    turf.lineString(coords)

  fromTurfFeature: (feature) ->
    @setLatLngs(turfFlip(feature).geometry.coordinates)

L.LayerGroup.include
  getLayerUUID: (layer) ->
    layer.feature.properties.uuid

  hasUUIDLayer: (layer) ->
    if !!layer && layerUUID = @getLayerUUID(layer)
      for id, l of @_layers
        if @getLayerUUID(l) == layerUUID
          return true
    return false

class L.PolygonSliceIcon extends L.DivIcon
  options:
    iconSize: [22, 22]
    className: "leaflet-polygon-slice-icon"
    html: ""
