FROM php:7.4-fpm

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    nginx \
    && docker-php-ext-install mysqli \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório para logs do Nginx
RUN mkdir -p /var/log/nginx

# Copiar arquivos de configuração
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.php /var/www/html/
COPY composer.json /var/www/html/

# Definir o diretório de trabalho
WORKDIR /var/www/html

# Instalar dependências PHP
RUN composer install

# Expor a porta 80 para o Nginx
EXPOSE 80

# Comando para iniciar o Nginx e o PHP-FPM
CMD service nginx start && php-fpm
