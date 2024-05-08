FROM node:20.13.0-alpine3.19  AS build

WORKDIR /usr/src/app

COPY package.json yarn.lock .yarnrc.yml ./
COPY .yarn ./.yarn

RUN yarn 

COPY . . 

RUN yarn run build 
RUN yarn workspaces focus --production && yarn cache clean 

FROM node:20.13.0-alpine3.19 

COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/node_modules ./node_modules

EXPOSE 3000
 
CMD ["yarn","run","start:prod"]