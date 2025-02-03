# DevOps

## 1-1 Why should we run the container with a flag -e to give the environment variables?

Les variables d'environnement sont des IP / mots de passes secrets. Ils ne doivent pas être public. ainsi, les mettre dans un dockerfile n'assure pas leur sécurité, les passer via -e permet de les renseigner au lancement seulement. (volatile et non partagé)

## 1-2 Why do we need a volume to be attached to our postgres container?

Le volume permet de rendre les données persistantes, cela signifie que si le container est supprimé, il pourra "régénérer" partiellement son état grâce au volume associé. Ici, si j'ajoute ou modifie des éléments de ma base de données, je ne repartirai pas de 0 après un restart de mon infra.

## 1-3 Document your database container essentials: commands and Dockerfile.

### 0. Dépendances

> Docker dépendence :  
> 'adminer' image

Le Dockerfile mybd est à la racine du repo git ou en à ce lien : [Dockerfile](dockerfile)

### 1. Build l'image

Il n'y a rien de particulier pour le build :  
`docker build -t enzouz12/mybd .`

### 2. Créer le réseau interne

Créez un network 'app-network' :  
`docker network create app-network`

### Lancer les images

#### a.

```docker
docker run --name=mybd --net=app-network  -e=POSTGRES_DB=db -e=POSTGRES_USER=usr -e=POSTGRES_PASSWORD=pwd -v=/storage:/var/lib/postgresql/data -d enzouz12/mybd
```

> Bien s'assurer que le réseau dans --net soit celui créer en amont

> Ce sont les 3 variables d'environnement, on les renseigne au build  
> `-e=POSTGRES_DB=db`  
> `-e=POSTGRES_USER=usr`  
> `-e=POSTGRES_PASSWORD=pwd`

> Permet de persister les données de postgres dans notre dossier storage
> v=/storage:/var/lib/postgresql/data

#### b.

```docker
docker run --name=adminer --net=app-network -p=8090:8080 -d adminer
```

Rien de particulier

## 1-4 Why do we need a multistage build? And explain each step of this dockerfile.

On compile le code dans un premier temps avec une image qui a la capacité de le faire puis on l'execute dans une image qui ne peut que lire du code compilé du coup notre image finale n'est pas "surchargé", elle ne fait que executer le code sans avoir de fonctionnalités en plus non necessaire pour faire marcher l'API

D'abbord on copie le pom.xml et le src du projet dans une image (JDK), on le compile avec maven dans un jar, jar qui sera copié dans la l'image (JRE) finale avant d'etre lancé
