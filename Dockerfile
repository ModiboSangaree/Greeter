
# Parent image from debian distribution
#FROM debian:stable-slim
# Upgrade system and package manager
#RUN apt-get update && apt-get upgrade -y
# Install tools for C++
#RUN apt-get install -y cmake ninja-build build-essential
#COPY . MyProject
# Create building directory
#RUN mkdir MyProject/build
# Configure and build
#RUN cd MyProject/build && cmake -G "Ninja" .. && ninja && ninja install
#Clean to keep the image small
#RUN rm -rf MyProject && apt-get purge -y cmake ninja-build
#CMD greet
# ---- Etape 1 : "build" 
# Parent image from debian distribution
FROM debian:stable-slim AS build
# Installer les outils C++ (une seule commande = une seule couche)
RUN apt-get update \
 && apt-get install -y --no-install-recommends cmake ninja-build g++ \
 && rm -rf /var/lib/apt/lists/*
# Copy source code in /src
WORKDIR /src
COPY . .
# Configurer, compiler, tester puis installer dans /install
RUN cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release \
 && cmake --build build \
 && ctest --test-dir build --output-on-failure \
 && cmake --install build --prefix /install
# ---- Etape 2 : image finale --------------------------------------------
# On repart d'une image propre : ni compilateur, ni code source
FROM debian:stable-slim
COPY --from=build /install/bin/HelloWorld /usr/local/bin/HelloWorld
# Commande lancee par "docker run"
CMD ["HelloWorld"]
