# Spécification des objectifs

Le projet en soit possède déjà quelques objectifs:

 - offrir un _middleware_ en Vala
    - peu de dépendance (glib + gio + libsoup)
    - facilement réutilisable (stream, structure définies par glib, ...)
    - simple et minimal

 - produire un micro-framework qui répond à des besoins réels
    - traitement asynchrone
    - middlewares built-in

 - produire des composantes pour facilité la réalisation des fonctionnalités
    - authentification (OAuth2, PKCS11, ...)
    - cache (Memcached)
    - base de données

 - favoriser l'utilisation des librairies existantes (élément clé d'un micro-framework)
    - gresource pour compiler les resources
    - gio pour le traitement asynchrone des streams
    - glib en général
    - GDA pour les bases de données
    - GSettings pour le paramétrage des application
    - libuuid pour les UUID
    - gcrypt pour le hachage et le chiffrement
    - libgpg pour le chiffrement asymétrique
    - GSL pour le calcul numérique

La meilleure façon, c'est de consulter les frameworks existant, car ils ont été
bâti pour répondre à des besoins réels.

 - Node.js
 - Flask
 - Ruby on Rails
 - Kohana

# Résumé des besoins fonctionnels du framework

La plupart des besoins sont implémentés actuellemnt, mais nécéssite des tests
unitaires.

Les besoins qui n'ont pas encore été couvert nécéssite une bonne conception et
des tests unitaires aussi!

 - abstraction de requête/réponse

 - serveur
    - événements
       - consulter Node.js
    - implémentations
        - FastCGI
           - tests d'intégration (génériques aux implémentations?)
        - libsoup (serveur _built-in_)
        - ?
    - sessions natives
    - authentification HTTP

 - requête
    - paramètres calculés
       - généralement les variables dans l'URL, mais l'implantation est propre
         au matcher (on peut extraire l'information qu'on veut)
    - query HTTP
    - body
       - chunked
       - multipart
    - headers
    - cookies
    - version du protocole

  - réponse
     - status
        - constantes préféfinies (libsoup)
        - redirection HTTP
        - code d'erreur client (4xx)
        - code d'erreur serveur (5xx)
     - headers
     - cookies
     - body
        - chunk, streaming, etc...

 - routage
    - selon la méthode (eg. GET, POST, PUT, DELETE, ...)
    - selon l'URL (eg. règle, expression régulière)
    - low-level avec un matcher

 - templating
    - depuis une resource
    - depuis un fichier
    - depuis une chaîne
