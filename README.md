# Agenda docente · versión para compartir con compañeros

Cada docente crea su cuenta con correo y contraseña. Su agenda (horario, planeaciones, asistencia, notas, registros y archivos) es privada: nadie más la ve, ni siquiera quien administra el proyecto desde la página.

La página vive en **GitHub Pages** (gratis) y los datos se guardan en **Supabase** (plan gratuito).

**Archivos de esta carpeta:**

| Archivo | Para qué sirve |
|---|---|
| `index.html` | La agenda |
| `config.js` | Aquí se pega la conexión con Supabase (paso 3) |
| `supabase.sql` | Crea la base de datos y las reglas de privacidad (paso 2) |
| `README.md` | Esta guía |

La configuración la hace **una sola persona, una sola vez** (unos 20 minutos). Tus compañeros solo abren el enlace y crean su cuenta.

> **Estado:** los pasos 1, 2 y 3 ya están hechos en el proyecto «Plataforma de notas» (`dkgoyrnsxmhvkzutreyx`), y `config.js` ya trae la conexión. Faltan los pasos 4, 5 y 6.

---

## Paso 1 · Crear el proyecto en Supabase

1. Entra a https://supabase.com y crea una cuenta gratuita.
2. Pulsa **New project**. Ponle un nombre (por ejemplo `agenda-docente`), escribe una contraseña para la base de datos (guárdala) y elige la región más cercana (por ejemplo *São Paulo* o *East US*).
3. Espera un par de minutos a que el proyecto termine de crearse.

## Paso 2 · Crear la base de datos

1. En el menú de la izquierda abre **SQL Editor** y pulsa **New query**.
2. Abre el archivo `supabase.sql`, copia todo su contenido y pégalo.
3. Pulsa **Run**. Debe decir *Success*.

Esto crea:
- Una tabla donde cada docente tiene una sola fila con su agenda.
- Una carpeta privada llamada `archivos`, donde cada docente solo puede usar su propia subcarpeta.

## Paso 3 · Conectar la página con Supabase

1. En Supabase abre **Project Settings → API** (puede aparecer como **Data API** o **API Keys**).
2. Copia la **Project URL** (algo como `https://abcdxyz.supabase.co`).
3. Copia la clave pública **anon** (también puede llamarse **publishable**).
4. Abre `config.js` con el Bloc de notas y pega los dos valores entre las comillas:

```js
window.AGENDA_CONFIG = {
  url: "https://abcdxyz.supabase.co",
  anonKey: "eyJhbGciOi..."
};
```

> **Importante:** nunca pegues la clave **service_role** (o *secret*). La clave *anon* puede ser pública porque las reglas del paso 2 impiden que un docente vea los datos de otro.

## Paso 4 · Permitir que tus compañeros creen su cuenta sin correo de confirmación

El servicio de correo que trae Supabase sirve solo para pruebas: envía muy pocos correos por hora y solo a los miembros de tu equipo en Supabase. Por eso conviene que las cuentas se creen sin confirmación por correo:

1. En Supabase ve a **Authentication → Sign In / Providers** (en algunas versiones, **Providers → Email**).
2. Desactiva **Confirm email** y guarda.

Así, cada docente escribe su correo y una contraseña y entra de inmediato.

## Paso 5 · Publicar en GitHub Pages

1. Crea una cuenta en https://github.com si no la tienes.
2. Crea un repositorio nuevo (por ejemplo `agenda-docente`) y márcalo como **Public**. GitHub Pages gratuito necesita repositorios públicos.
   - Esto no expone ningún dato: en el repositorio solo está la página. Los datos de los docentes están en Supabase, protegidos por contraseña.
3. En el repositorio pulsa **Add file → Upload files**, arrastra `index.html`, `config.js`, `supabase.sql` y `README.md`, y pulsa **Commit changes**.
4. Ve a **Settings → Pages**. En *Source* elige **Deploy from a branch**, rama **main**, carpeta **/ (root)**, y guarda.
5. En uno o dos minutos aparece el enlace, algo como `https://tu-usuario.github.io/agenda-docente/`.

## Paso 6 · Indicarle a Supabase cuál es la dirección de la agenda

1. En Supabase ve a **Authentication → URL Configuration**.
2. En **Site URL** pega el enlace de GitHub Pages del paso 5.
3. En **Redirect URLs** agrega ese mismo enlace y guarda.

## Paso 7 · Compartir

Envía el enlace a tus compañeros. Cada uno:

1. Toca **¿No tienes cuenta? Crear una**.
2. Escribe su nombre, su correo y una contraseña de al menos 8 caracteres.
3. Empieza en **Mis datos**: agrega sus asignaturas, arma su horario y revisa las fechas de los periodos.

La agenda ya viene con la configuración del SIEE del colegio:
- Tres periodos que valen 30 %, 30 % y 40 %.
- Escala de 20 a 100.
- Componentes de la nota del periodo: conocimiento 30 %, evaluación 10 %, procedimentales 30 %, y heteroevaluación, autoevaluación y coevaluación con 10 % cada una.
- Una nota faltante cuenta como 0.

Las fechas de los periodos de 2027 vienen aproximadas: cada docente debe ajustarlas en **Periodos**.

---

## Mantenimiento

**Vacaciones: el proyecto se pausa.** En el plan gratuito, Supabase pausa los proyectos que pasan una semana sin uso (por ejemplo, en vacaciones de diciembre o de mitad de año). Los datos no se pierden. Para reactivarlo:
1. Entra a Supabase.
2. Abre el proyecto.
3. Pulsa **Resume project**.

Supabase avisa por correo antes de pausarlo. Reactívalo pronto: un proyecto pausado solo se puede restaurar durante un tiempo limitado.

**Copias de seguridad.** Pide a cada docente que use el botón **Respaldo** al cierre de cada periodo y guarde el texto en su correo o en un archivo.

**Contraseña olvidada.** Hay dos caminos:
- **Sin configurar nada más:** el docente no podrá recuperarla por correo, porque el correo de prueba de Supabase no le llega. Como administrador, entra a **Authentication → Users**, elimina la cuenta de esa persona y pídele que la cree de nuevo. Ojo: al eliminar la cuenta se borra también su agenda. Solo podrá recuperarla si tiene un **Respaldo** guardado, que luego restaura en su cuenta nueva.
- **Recomendado si son muchos docentes:** configura un correo propio en **Authentication → Emails → SMTP Settings**. Puede ser un servicio gratuito como Brevo o Resend, o el correo del colegio si lo permite. Así funciona el botón **Olvidé mi contraseña**. En ese caso puedes volver a activar *Confirm email*.

**Cerrar el registro.** Cuando todos tus compañeros tengan su cuenta, puedes desactivar **Allow new users to sign up** en **Authentication → Sign In / Providers**. Así nadie más podrá crear cuentas con el enlace. Las cuentas nuevas las agregas tú desde **Authentication → Users → Add user**.

**Fin del año lectivo.** En **Mis datos → Fin del año lectivo** cada docente puede borrar sus datos cuando termine el último periodo. Puede elegir entre borrar solo los datos del año (conserva su horario y configuración, y los periodos pasan al año siguiente) o borrar absolutamente todo. Antes, la agenda le ofrece descargar el Excel del año y guardar un respaldo. Los archivos adjuntos se eliminan de Supabase.

**Cambiar la contraseña.** Cada docente puede hacerlo en **Mis datos → Tu cuenta**.

## Pasar tus datos desde la agenda de Claude

1. En tu agenda actual (la de claude.ai) pulsa **Respaldo → Copiar respaldo**.
2. En la nueva agenda, entra con tu cuenta, pulsa **Respaldo**, pega el texto en el recuadro de abajo y pulsa **Restaurar**.

Los archivos que subiste en la versión de Claude (horario oficial y planeaciones adjuntas) no pasan con el respaldo: hay que subirlos de nuevo.

## Límites del plan gratuito de Supabase

Para un grupo de docentes sobra:
- 500 MB de base de datos.
- 1 GB para archivos.
- Hasta 20 MB por archivo, según la regla de `supabase.sql`.
