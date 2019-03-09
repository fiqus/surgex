<template>
  <div>
    <form v-on:submit="submit">
      <div class="form-login">
        <h1 class="center login-message">Inicio de Sesión</h1>
        <div>
          <input name="email" class="button-login" type="text" v-model="login.email" placeholder="Email" required>
        </div>
        <div>
          <input name="password" class="button-login" type="password" v-model="login.password" placeholder="Contraseña" required>
        </div>
        <button :disabled="disabled">Iniciar Sesión</button>
        <button type="button" v-on:click="recover" :disabled="disabled">Olvidé mi Contraseña</button>
      </div>
    </form>
  </div>
</template>
<script>
export default {
  data() {
    return {
      login: {
        email: "",
        password: ""
      },
      disabled: false
    }
	},
	computed: {
    missingRequiredFields: function () { return this.login.email === "" || this.login.password === ""; }
	},
	methods: {
    submit: function (event) {
      event.preventDefault();
      if (this.missingRequiredFields) {
        return this.$awn.warning("Por favor complete su email y contraseña.");
      }

      this.disabled = true;
      this.$store.dispatch("login", this.login)
        .then((user) => {
          this.$awn.success(`¡Bienvenido ${user.firstName}!`);
          this.$router.replace({name: "home"});
        }).catch((err) => {
          this.disabled = false;
          if (err && err.code === "EMAIL_NOT_EXISTS") {
            this.$awn.alert("El email no está registrado en el sistema.");
          } else if (err && err.code === "USER_DISABLED") {
            this.$awn.alert("Su usuario se encuentra desactivado.");
          } else if (err && err.code === "WRONG_PASSWORD") {
            this.$awn.alert("La contraseña es incorrecta.");
          } else {
            this.$awn.alert("No se pudo iniciar sesión. Intente nuevamente en unos instantes.");
          }
        });
    },
    recover: function () {
      this.$router.replace({name: "recover"});
    }
	}
}
</script>
