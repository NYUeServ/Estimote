# Estimote-New

## Classes

### Sensor
The `Sensor` class defines the metrics we wish to store
about each Estimote sensor. Each `Sensor` object's info in 
the `SensorManager`'s `connectedSensors` array is subject to 
change, per the interval of update defined by `SensorManager`.

### Occupancy Detector
The `OccupancyDetector` class implements a set of
methods that accept defined interrupts and calculates
the "occupancy" for the chair in which the Estimote
sensor is attached. This class will keep a constantly-updated
list of connect sensors as a binary (1) occupied, or (0) unoccupied.
This list will be forwarded to the AWS servers at defined intervals.
Each `Sensor` will get its own cooldown timer which ticks for the defined
interval. It is reset if an iterrupt is detected. If it times out, the sensor
is then considered unoccupied.

### Log Manager
The `LogManager` is a singleton class that handles the conversion of 
`Sensor` objects to JSON files. The `LogManager` will maintain a rotating 
list of sensor logs, which detail their acceleration, temp, etc. Pushes
occupancy list from the `Occupancy Detector` to the AWS Server.

### Sensor Manager
The `SensorManager` is a singleton class that controls communication
with the Estimote sensors, and manages a list of these sensors. The
class is indented to update the sensors asyncronously, and their infomration
can be read from the `connectedSensors` array.

