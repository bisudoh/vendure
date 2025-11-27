FROM node:22

# --------------------------------------------------
# 1. Workspace setup
# --------------------------------------------------
WORKDIR /usr/src/app

# --------------------------------------------------
# 2. Install global tools (Lerna)
# --------------------------------------------------
RUN npm install -g lerna

# --------------------------------------------------
# 3. Set environment vars required by Lerna
# --------------------------------------------------
ENV CI=true \
    NPM_CONFIG_LOGLEVEL=warn \
    NODE_ENV=production \
    LERNA_ROOT_PATH=/usr/src/app \
    LERNA_PACKAGE_DIRS="packages/*" \
    FORCE_COLOR=1

# --------------------------------------------------
# 4. Copy package manifests first (for cached install)
# --------------------------------------------------
COPY package.json .
COPY package-lock.json .
COPY lerna.json .
COPY packages ./packages

# --------------------------------------------------
# 5. Install dependencies
# --------------------------------------------------
RUN npm install --production

# --------------------------------------------------
# 6. Bootstrap Lerna packages
# --------------------------------------------------
#RUN lerna bootstrap

COPY package.json package-lock.json ./
RUN npm install -g lerna && npm install --production

COPY . .

# --------------------------------------------------
# 7. Build the monorepo
# --------------------------------------------------
RUN npm run build

# --------------------------------------------------
# 8. Run your application
# --------------------------------------------------
CMD ["npm", "start"]
