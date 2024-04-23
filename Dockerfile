FROM node:20.12-alpine as npm-dependencies
WORKDIR /app
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install

FROM laravelsail/php83-composer:latest
COPY --from=npm-dependencies /app/node_modules /app/node_modules
RUN docker-php-ext-install mysqli pdo pdo_mysql intl
WORKDIR /app
COPY . .
RUN composer install
CMD [ "php", "artisan", "serve", "--host", "0.0.0.0" ]
