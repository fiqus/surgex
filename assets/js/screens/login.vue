<template>
  <div class="card form-login bg-light">
    <article class="card-body">
      <h1 class="card-title text-center mb-4 mt-1">Bienvenido</h1>
      <hr>
      <form v-on:submit.prevent="submit"> 
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text"> <i class="fa fa-user"></i> </span>
            </div>
            <input class="form-control" type="email" v-model="login.email" placeholder="Email" required>
          </div>
        </div>
        <div class="form-group">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text"> <i class="fa fa-lock"></i> </span>
            </div>
            <input type="password" class="form-control" v-model="login.password" placeholder="Contraseña" required>
          </div>
        </div>
        <div class="form-group">
          <button class="btn btn-primary btn-block shadow" :disabled="disabled">Iniciar Sesión</button>
        </div>
        <p class="text-center"><a href="#" v-on:click="recover" :disabled="disabled">Olvidé mi Contraseña</a></p>
      </form>
    </article>
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
    submit: function () {
      if (this.missingRequiredFields) {
        return this.$awn.warning("Por favor complete su email y contraseña.");
      }

      this.disabled = true;
      this.$store.dispatch("login", this.login)
        .then((user) => {
          this.$awn.success(`¡Bienvenido ${user.first_name}!`);
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
