<template>
  <div>
    <form action="/api/token" method="post" v-on:submit="validateForm">
      <h2 class="center"></h2>

      <div class="form-login">
        <h1 class="center login-message">Bienvenido</h1>
        <div>
          <input name="email" class="button-login" type="text" v-model="email" placeholder="Usuario" required>
        </div>
        <div>
          <input name="password" class="button-login" type="password" v-model="password" placeholder="Contraseña" required>
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
      email: "",
      password: "",
      formSubmit: false
    }
	},
	computed: {
    missingUser: function () { return this.login.user === ''; },
    missingPassword: function () { return this.login.password === ''; },
	},
	methods: {
    validateForm: function (event) {
      this.formSubmit = true;
      if (this.missingName || this.missingPassword) {
        event.preventDefault();
      } 
    }
	}
}
</script>
