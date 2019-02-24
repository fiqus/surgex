<template>
  <div>
    <form action="/api/token" method="post" v-on:submit="validateForm">
      <h2 class="center"></h2>

      <div class="form-login">
        <h1 class="center login-message">Inicio de Sesión</h1>
        <div>
          <input name="email" class="button-login" type="text" v-model="login.email" placeholder="Email" required>
        </div>
        <div>
          <input name="password" class="button-login" type="password" v-model="login.password" placeholder="Contraseña" required>
        </div>
        <button>Iniciar Sesión</button>
      </div>
    </form>
  </div>
</template>
<script>
export default {
  created() {
  },
  data() {
    return {
      login: {
        email: "",
        password: ""
      },
      formSubmit: false,
      loading: false
    }
	},
	computed: {
    missingUser: function () { return this.login.user === ''; },
    missingPassword: function () { return this.login.password === ''; },
	},
	methods: {
    validateForm: function (event) {
      this.formSubmit = true;
      event.preventDefault();
      if (this.missingName || this.missingPassword) {
        return false;
      } 
      this.loading = true;
      this.$store.dispatch("login", this.login)
        .then((data) => {
          this.$router.push({name: "home"});
        })
    }
	}
}
</script>
