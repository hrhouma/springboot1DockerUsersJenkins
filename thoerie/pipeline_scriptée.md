L'autre type de pipeline majeur dans le contexte des outils d'intégration continue et de déploiement continu (CI/CD) comme Jenkins est la **pipeline scriptée** (Scripted Pipeline). Alors que la pipeline déclarative se concentre sur une structure hautement lisible et facile à comprendre pour définir "quoi faire", la pipeline scriptée offre une flexibilité plus grande en permettant aux utilisateurs de définir "comment le faire" en utilisant du code Groovy plus complexe.

### Caractéristiques des pipelines scriptées :

- **Flexibilité :** Les pipelines scriptées offrent une flexibilité totale pour écrire des scripts complexes, y compris la logique conditionnelle, les boucles et les try/catch pour la gestion des erreurs.
- **Contrôle :** Elles permettent un contrôle précis sur le pipeline, en donnant la possibilité d'exécuter des scripts Groovy presque sans restriction.
- **Syntaxe :** La syntaxe est basée sur Groovy, ce qui signifie qu'elle peut être moins intuitive pour ceux qui ne sont pas familiers avec le langage ou la programmation de scripts en général.

### Exemple de pipeline scriptée :

```groovy
node {
    stage('Build') {
        echo 'Building..'
        // Commandes pour construire l'application
    }
    stage('Test') {
        echo 'Testing..'
        // Commandes pour tester l'application
    }
    stage('Deploy') {
        echo 'Deploying..'
        // Commandes pour déployer l'application
    }
}
```

Dans cet exemple de pipeline scriptée, `node` est un bloc qui définit l'environnement d'exécution où le pipeline va s'exécuter. À l'intérieur de ce bloc, les différentes `stage`s sont définies de manière similaire à la pipeline déclarative, mais avec la possibilité d'ajouter des structures de contrôle Groovy plus complexes autour et à l'intérieur des étapes.

### Comparaison avec la pipeline déclarative :

- **Simplicité vs. Flexibilité :** Les pipelines déclaratives sont plus simples à écrire et à comprendre, idéales pour des scénarios standardisés. Les pipelines scriptées, en revanche, sont préférables pour des cas d'utilisation plus complexes nécessitant une logique personnalisée.
- **Maintenance :** Les pipelines scriptées peuvent être plus difficiles à maintenir en raison de leur complexité accrue, surtout si la logique personnalisée devient volumineuse ou compliquée.
- **Apprentissage :** La courbe d'apprentissage pour les pipelines scriptées peut être plus raide, surtout pour ceux qui ne sont pas familiers avec Groovy.

En résumé, le choix entre une pipeline déclarative et une pipeline scriptée dépend des besoins spécifiques du projet, de la complexité du processus de CI/CD, et de la familiarité de l'équipe avec le langage Groovy.
