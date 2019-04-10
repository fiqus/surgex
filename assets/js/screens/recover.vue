<template>
  <div>
    <form v-on:submit.prevent="submit" v-if="!sent">
      <div class="form-login">
        <h1 class="center login-message">Recuperación de Acceso</h1>
        <label>Ingrese el email con el que está registrado en el sistema:</label>
        <div>
          <input name="email" type="email" v-model="email" placeholder="Email" required>
        </div>
        <button :disabled="disabled">Recuperar Contraseña</button>
        <button type="button" v-on:click="back" :disabled="disabled">Volver</button>
      </div>
    </form>
    <div v-if="sent">
      <h3>Se envió un email a <b>{{ email }}</b> para recuperar la contraseña.</h3>
      Revise su casilla e ingrese al link enviado, que tiene una validez de 1 hora.
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      email: "",
      disabled: false,
      sent: false
    }
	},
	computed: {
    missingRequiredFields: function () { return this.email === ""; }
	},
	methods: {
    submit: function () {
      if (this.missingRequiredFields) {
        return this.$awn.warning("Por favor complete su email.");
      }

      this.disabled = true;
      this.$store.dispatch("postRecover", this.email)
        .then((res) => {
          this.$awn.success("El email se envió correctamente.");
          this.sent = true;
        }).catch((err) => {
          this.disabled = false;
          if (err && err.code === "EMAIL_NOT_EXISTS") {
            this.$awn.alert("El email no está registrado en el sistema.");
          } else {
            this.$awn.alert("No se pudo recuperar la contraseña. Intente nuevamente en unos instantes.");
          }
        });
    },
    back: function () {
      this.$router.replace({name: "login"});
    }
	}
}
</script>
