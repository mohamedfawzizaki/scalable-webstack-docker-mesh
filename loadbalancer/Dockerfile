# syntax=docker/dockerfile:1.4
FROM nginx
RUN --mount=type=secret,id=front-sec

CMD [ "nginx", "-g", "daemon off;"]    