# Exportar a GitHub usando Git
Git es un sistema de control de versiones que nos ayudará a llevar el seguimiento a todo el trabajo realizado durante el proyecto.
## Instalación de Git
Ir a la siguiente [vínculo](https://git-scm.com/download/win) y seguir todos los pasos sólo dando **siguiente**.

## Definir el nombre y correo
Este paso es importante para llevar el registro de las personas que realizan las modificaciones.

1. Abrir la consola (símbolo de sistema) con `Windows + R` y poner `cmd`
2. Definir tu nombre de usuario: usar el comando

`git config --global user.name "Tu nombre"`

3. Definir tu nombre correo: usar el comando

`git config --global user.email "tucorreo@gmail.com"`

## Inicializar un repositorio
1. Abrir la consola
2. Ir a la carpeta donde se tengan los archivos que se quieren subir.
3. Copiar el directorio, a la que llamaremos `mi_dir`
4. Poner en la terminal `cd mi_dir`
4. Poner `git init`

## Agregar archivos
1. Poner `git add nombre_archivo.extensión`. 

**Nota**: Si el nombre del archivo tiene espacios poner el nombre entre comillas.

2. Agregar un *commit* con `git commit -m "Agregando mi primer archivo"`

## Subir archivos a Github
1. Crear un nuevo repositorio y copiar la url.
2. Poner en la terminal

`git remote add origin https://github.com/nobre_usuario_github/tu_repositorio.git`

**Nota**: si ya se tiene la el git inicializado este paso ya no es necesario.

3. Hacer el Push con

`git push -u origin master`