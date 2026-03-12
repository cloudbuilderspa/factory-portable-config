# Diagram Architect Skill

## Descripción
Esta skill permite crear diagramas de arquitectura cloud, software y sistemas usando código Python con la librería `diagrams`.

## Instalación
```bash
pip install diagrams graphviz
```

## Ejemplos de Código

### 1. Diagrama AWS Básico
```python
from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2, Lambda
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB, Route53

with Diagram("Web Service Architecture", show=False):
    dns = Route53("DNS")
    lb = ELB("Load Balancer")
    
    with Cluster("EC2 Instances"):
        servers = [EC2("server1"), EC2("server2")]
    
    db = RDS("PostgreSQL")
    
    dns >> lb >> servers >> db
```

### 2. Diagrama con Clusters
```python
from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS
from diagrams.aws.database import RDS
from diagrams.aws.network import Route53, ELB

with Diagram("Microservices", show=False):
    dns = Route53("dns")
    lb = ELB("lb")
    
    with Cluster("Services"):
        svc = [ECS("svc1"), ECS("svc2"), ECS("svc3")]
    
    with Cluster("DB Cluster"):
        db_primary = RDS("primary")
        db_primary - RDS("replica")
    
    dns >> lb >> svc >> db_primary
```

### 3. Diagrama On-Premises
```python
from diagrams import Cluster, Diagram
from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.network import Nginx
from diagrams.onprem.queue import Kafka

with Diagram("On-Premise Architecture", show=False):
    nginx = Nginx("nginx")
    
    with Cluster("App Servers"):
        apps = [Server("app1"), Server("app2")]
    
    with Cluster("Data Layer"):
        redis = Redis("cache")
        db = PostgreSQL("db")
    
    kafka = Kafka("events")
    
    nginx >> apps >> redis
    apps >> db
    apps >> kafka
```

### 4. Diagrama Kubernetes
```python
from diagrams import Cluster, Diagram
from diagrams.k8s.compute import Pod, Deployment
from diagrams.k8s.network import Service
from diagrams.k8s.storage import PVC

with Diagram("K8s Stateful App", show=False):
    with Cluster("Apps"):
        svc = Service("svc")
        deploy = Deployment("deploy")
        pods = [Pod("pod1"), Pod("pod2")]
    
    with Cluster("Storage"):
        pvc = PVC("data")
    
    svc >> deploy >> pods >> pvc
```

### 5. Diagrama GCP
```python
from diagrams import Cluster, Diagram
from diagrams.gcp.analytics import BigQuery, Dataflow, PubSub
from diagrams.gcp.compute import AppEngine, Functions
from diagrams.gcp.iot import IotCore
from diagrams.gcp.storage import GCS

with Diagram("GCP Data Pipeline", show=False):
    with Cluster("IoT"):
        devices = [IotCore("device1"), IotCore("device2")]
    
    pubsub = PubSub("pubsub")
    dataflow = Dataflow("pipeline")
    
    with Cluster("Storage"):
        bq = BigQuery("bigquery")
        gcs = GCS("storage")
    
    devices >> pubsub >> dataflow >> [bq, gcs]
```

## Parámetros de Graphviz

Personalizar el estilo del diagrama:
```python
with Diagram(
    "My Diagram",
    graph_attr={
        "bgcolor": "transparent",
        "layout": "dot",
        "rankdir": "LR"
    },
    node_attr={
        "style": "filled",
        "fillcolor": "lightblue"
    },
    edge_attr={
        "color": "black"
    }
):
    # componentes
```

## Recursos
- Repo: https://github.com/mingrammer/diagrams
- Documentación: https://diagrams.mingrammer.com
