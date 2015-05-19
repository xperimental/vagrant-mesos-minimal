# vagrant-mesos-minimal
This repository contains a vagrant configuration for a minimal Apache Mesos environment which can run Docker images using Marathon. Service discovery is provided using bamboo and HAProxy.

## Usage
To run this VM install [vagrant](https://www.vagrantup.com), clone this repository and run the following command inside the repository directory:
```bash
$ vagrant up
```

## Ports mapped
The VM automatically maps ports to the host system for all services provided:

| Host | Guest | Service              |
|------|-------|----------------------|
| 5050 | 5050  | Mesos Master         |
| 5051 | 5051  | Mesos Slave          |
| 8000 | 8000  | Bamboo Configuration |
| 8080 | 8080  | Marathon             |
| 9000 | 80    | HAProxy              |

## Links

* [Apache Mesos](http://mesos.apache.org/)
* [Marathon](https://mesosphere.github.io/marathon/)
* [Docker](https://www.docker.com/)
* [Bamboo](https://github.com/QubitProducts/bamboo)
* [HAProxy](http://www.haproxy.org/)
