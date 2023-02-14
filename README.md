# Osmium Tool on Docker

Read the [tool manual](http://osmcode.org/osmium-tool/) for detailed usage information.

## Example usage

Extract Greece from the planet download:

```bash
docker run -it -v ${PWD}:/data ssubbotin/osmium-tool extract --bbox=17.682871,33.679590,30.404538,42.269466 -o greece.osm.pbf planet-latest.osm.pbf
```

Filter all buildings, highways and beaches from the extract:

```bash
docker run -it -v ${PWD}:/data ssubbotin/osmium-tool tags-filter -o greece-filtered.osm.pbf greece.osm.pbf building highway natural=beach
```
