<template>
  <!--<div>
    <form v-on:submit="submit">
      <div class="form">
        <h1 class="center login-message">Inicio de Sesión</h1>
        <div class="input-group mb-3">
          <input class="form-control" v-model="login.email" placeholder="Email" required>
        </div>
        <div class="input-group mb-3">
          <input type="password" class="form-control" v-model="login.password" placeholder="Contraseña">
        </div>
        <button class="btn btn-primary" :disabled="disabled">Iniciar Sesión</button>
        <button class="btn btn-primary" type="button" v-on:click="recover" :disabled="disabled">Olvidé mi Contraseña</button>
      </div>
    </form>
  </div>
  -->

  <div class="container">
    <form class="form-signin">
      <h2 class="form-signin-heading">Please sign in</h2>
      <label for="inputEmail" class="sr-only">Email address</label>
      <input type="email" id="inputEmail" class="form-control" placeholder="Email address" required autofocus>
      <label for="inputPassword" class="sr-only">Password</label>
      <input type="password" id="inputPassword" class="form-control" placeholder="Password" required>
      <div class="checkbox">
        <label>
          <input type="checkbox" value="remember-me"> Remember me
        </label>
      </div>
      <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
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
