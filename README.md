# Estimote-New

## Classes

### Sensor
The `Sensor` class defines the metrics we wish to store
about each Estimote sensor. Each `Sensor` object's info in 
the `SensorManager`'s `connectedSensors` array is subject to 
change, per the interval of update defined by `SensorManager`

### Data Processor
The `DataProcessor` class defines a list of methods to parse
the JSON infomration stored by the `LogManager`. Using tweakable
thresholds, the `DataProcessor` will destill the sensor information
down to a (0) if the seat is unoccupied or (1) if the seat is occupied

The number of seats available can then be calculated by summing the number of
(1)s and divding by the total numebr of sensors reported by the `SensorManager`

### Sensor Manager
The `SensorManager` is a singleton class that controls communication
with the Estimote sensors, and manages a list of these sensors. The
class is indented to update the sensors asyncronously, and their infomration
can be read from the `connectedSensors` array

### Communication Manager
The `CommunicationManager` is a singleton class that controls communication
with AWS. The states of each sensor are sent as JSON via HTTP at defined intervals.
The JSON contains a list of integers (0 or 1), by Estimote sensor ID name.
0: Unoccupied seat
1: Occupied seat

