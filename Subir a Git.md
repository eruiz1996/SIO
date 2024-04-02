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
Este paso sólo se realiza una vez por repositorio local.
1. Abrir la consola
2. Ir a la carpeta donde se tengan los archivos que se quieren subir.
3. Copiar el directorio, a la que llamaremos `mi_dir`
4. Poner en la terminal `cd mi_dir`
4. Poner `git init`

## Agregar archivos
1. Poner `git add nombre_archivo.extensión`. 

**Nota**: Si el nombre del archivo tiene espacios poner el nombre entre comillas.

Ejemplo: `git add "nombre archivo espacios.extensión"`

2. Agregar un *commit* con `git commit -m "Agregando mi primer archivo"`

## Subir archivos a Github
1. Crear un nuevo repositorio y copiar la url.
2. Poner en la terminal

`git remote add origin https://github.com/nombre_usuario_github/tu_repositorio.git`

**Nota**: si ya se tiene la el git inicializado este paso ya no es necesario.

3. Hacer el Push con

`git push -u origin master`

---

# Clonar un repositorio
1. Elegir el directorio deseado para clonar el repositorio (tener en cuenta que se copia toda el repositorio como una carpeta)
2. Usar el comando de clonar:

`git clone https://github.com/nombre_usuario_github/tu_repositorio.git`

---

# Actualizar un repositorio local
Cuando se trabaja desde dos o más repositorios locales, lo que significa que ya se clonó el repositorio en varios equipos, y sólo se desea actualizar los cambios (inclusión de archivos o actualización de ya existentes), se tiene que usar el comando:

`git pull origin master`

Esto suponiendo que se actualiza la rama principal.

---

# Renombrar un archivo
1. Ir al directorio local
2. Usar `mv` para renombrar: `git mv old_file_name new_file_name`
3. Añadir el nuevo archivo: `git add new_file_name`
4. Hacer el commit: `git commit -m "Rename file: old_file_name to new_file_name"`
5. Hacer el push: `git push`