FROM node:20

# Gerekli sistem kütüphaneleri (Puppeteer/Chromium için)
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    libxss1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Bağımlılıkları kur
RUN npm install express --legacy-peer-deps && npm install --legacy-peer-deps

# OpenAI anahtarı yoksa çökmeyi önle
ENV OPENAI_API_KEY="sahte_anahtar"

# Puppeteer ayarları
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Portu dinamik olarak dinleyen ve botu başlatan komut
CMD node -e "const express = require('express'); const app = express(); app.get('/', (req, res) => res.send('Bot Aktif!')); app.listen(process.env.PORT || 3000);" & npm run start
