# Resume Designer
Application de création de CV / Résumé.

![Resume Designer](https://github.com/julien-vanh/resume-designer/blob/80eed507114d479cfbb33f4bf4767490c9338b3d/store/screenshots/macos-1.png)
![Resume Designer](https://github.com/julien-vanh/resume-designer/blob/80eed507114d479cfbb33f4bf4767490c9338b3d/store/screenshots/macos-2.png)
![Resume Designer](https://github.com/julien-vanh/resume-designer/blob/80eed507114d479cfbb33f4bf4767490c9338b3d/store/screenshots/macos-3.png)
![Resume Designer](https://github.com/julien-vanh/resume-designer/blob/80eed507114d479cfbb33f4bf4767490c9338b3d/store/screenshots/macos-4.png)


## Application (app)
Projet monorepo, l'app se situe dans le dossier 'app'. Projet Xcode app SwiftUI universelle + MacOS Catalyst

## Site web vitrine (www)
Le site web se situe dans le dossier 'www'.

Nom de domaine sur AWS Route 53 : <b>resume-designer.com</b>

Le site est hébergé sur Firebase Hosting

### Installation
```
cd www
bundle install --path vendor/bundle
```

### Lancement en mode dev sur navigateur
```
cd www
ps aux |grep jekyll |awk '{print $2}' | xargs kill -9
bundle exec jekyll serve
```
Ou :
```
cd www
sh serve.sh
```

### Deploiement en prod
```
cd www
bundle exec jekyll build

firebase login
firebase deploy --only hosting
```
