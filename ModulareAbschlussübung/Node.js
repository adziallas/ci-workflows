# Verwende das Node.js Basis-Image
FROM node:14

# Setze das Arbeitsverzeichnis
WORKDIR /usr/src/app

# Kopiere die package.json
COPY package.json 

# Installiere die Abhängigkeiten
RUN npm install

# Kopiere den restlichen Quellcode
COPY .

# Exponiere den Port
EXPOSE 3000

# Starte die Anwendung
CMD ["npm", "start"]
