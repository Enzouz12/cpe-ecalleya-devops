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

## 1-5 Why do we need a reverse proxy?

Cela permet : De donner un point d'entré unique qui va venir questionner le/les back pour donner la réponse attendue a l'utilisateur

On peut faire du load balancing dessus par conséquent

D'un autyre cote cela rajoute de la securite en evitant de laisser ouvert un port (back ou BDD) à tout le monde afin d'obliger à passer par le reverse proxy pour les interroger

## 1-6 Pourquoi Docker Compose est-il si important ?

Docker Compose est essentiel pour orchestrer plusieurs conteneurs et gérer des configurations complexes. Ses principaux avantages sont :

- **Automatisation** : Permet de démarrer, arrêter et gérer plusieurs conteneurs en une seule commande (`docker-compose up/down`).
- **Lisibilité** : Une configuration centralisée dans un fichier `docker-compose.yml` simplifie la gestion et la reproductibilité de l’environnement.
- **Gestion des dépendances** : Assure que les services sont bien reliés et démarrés dans le bon ordre.
- **Facilité de mise en place** : Avec un seul fichier YAML, on peut rapidement lancer une stack complète (BDD, back, front, reverse proxy, etc.).
- **Portabilité** : Facilite la transition entre les environnements de développement, test et production.

---

## 1-7 Commandes essentielles de Docker Compose

| Commande                                   | Description                                                 |
| ------------------------------------------ | ----------------------------------------------------------- |
| `docker-compose up -d`                     | Démarre les services en arrière-plan (mode détaché)         |
| `docker-compose down`                      | Arrête et supprime tous les services définis                |
| `docker-compose ps`                        | Liste les conteneurs en cours d’exécution                   |
| `docker-compose logs -f`                   | Affiche les logs des conteneurs en temps réel               |
| `docker-compose build`                     | Construit les images définies dans le fichier               |
| `docker-compose restart`                   | Redémarre tous les services                                 |
| `docker-compose stop`                      | Arrête les conteneurs sans les supprimer                    |
| `docker-compose start`                     | Relance les conteneurs arrêtés                              |
| `docker-compose exec <service> <commande>` | Exécute une commande dans un conteneur en cours d'exécution |

---

## 1-8 Documentation du fichier `docker-compose.yml`

Ton fichier `docker-compose.yml` contient les éléments suivants :

1. **Définition des services** : Plusieurs services comme PostgreSQL, Adminer, potentiellement un backend et un reverse proxy.
2. **Configuration des réseaux** : Un réseau dédié pour permettre aux services de communiquer.
3. **Volumes persistants** : PostgreSQL utilise un volume pour éviter la perte des données.
4. **Variables d’environnement** : Pour sécuriser les informations sensibles (mots de passe, utilisateurs).
5. **Exposition des ports** : Pour rendre accessibles les services comme Adminer via le port `8090`.

---

## 1-9 Commandes de publication et images Docker Hub

### 1. Se connecter à Docker Hub

Avant de pousser une image sur Docker Hub, il faut s’assurer d’être connecté :

```sh
docker login
```

## 1-10 Pourquoi stocker nos images dans un registre en ligne ?

Stocker nos images dans un registre en ligne présente plusieurs avantages :

- **Accessibilité** : Permet aux autres membres de l’équipe et aux serveurs de récupérer l’image sans avoir à la reconstruire.
- **Déploiement facilité** : Dans un pipeline CI/CD, les images peuvent être tirées directement depuis Docker Hub ou un registre privé.
- **Versioning** : Possibilité de versionner les images (`v1`, `latest`, etc.), facilitant la gestion des mises à jour.
- **Sécurité et centralisation** : Un registre centralisé permet un meilleur contrôle et une meilleure gestion des accès et des mises à jour.
- **Scalabilité** : Une fois publiée, l’image peut être utilisée par plusieurs instances dans le cloud ou sur différentes machines sans duplication locale.

Exemple de commande pour récupérer une image stockée dans Docker Hub :

```sh
docker pull enzouz12/mybd:v1
```

## 2-1 What are testcontainers?

## 2-2 Document your Github Actions configurations.


