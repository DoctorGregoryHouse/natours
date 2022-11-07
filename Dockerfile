FROM node:latest  as build-stage

WORKDIR /app 
COPY entrypoint.sh /entrypoint.sh 
RUN chmod +x /entrypoint.sh 

# Copies the sourcecode to /app, since /app is the workdir 
ADD . . 

RUN npm install 

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["npm", "run", "dev"]

#CMD ["npm", "run", "build"] (does not work because it runs concurrently, 
# docker will continue with the script and the command won't be finished early enough
RUN npm run build 
#Stage 1: Only compiled App on nginx 

FROM nginx:latest 

COPY --from=build-stage /app/dist/ /usr/share/nginx/html 

#Copy default nginx.conf 
COPY --from=build-stage /app/nginx.conf /etc/nginx/conf.d/default.conf


