<template>
  <div>
    <div v-if="error"><h1 class="big-error-message" v-html="error"></h1></div>
    <div v-if="!loading">
      <h1 class="subtitle">Activación de Usuario</h1>
      <h3><b>{{ formatFullName(user) }}</b><br/>{{ user.email }}</h3>
      <p class="alert-warning">La contraseña debe tener al menos 6 caracteres.</p>

      <form v-on:submit="submit">
        <div>
          <label>Ingrese la contraseña:</label>
          <input name="password" type="password" v-model="user.password" required>
        </div>
        <div>
          <label>Repita y confirme la contraseña:</label>
          <input name="confirm" type="password" v-model="user.confirm" required>
        </div>
        <button :disabled="disabled">Activar Usuario</button>
      </form>
    </div>
  </div>
</template>
<script>
import {formatFullName} from "../utils";
const genericError = "No se pudo activar el usuario.<br/>Si el problema persiste, contacte al administrador.";

export default {
  data() {
    return {
      user: {},
      loading: true,
      disabled: false,
      error: null,
      formatFullName
    }
  },
  created() {
    this.$store.dispatch("getActivate", this.$route.query.token)
      .then((data) => {
        this.user = data;
        this.loading = false;
      })
      .catch((err) => {
        if (err && err.code === "WRONG_TOKEN") {
          this.$awn.alert("El código de activación no es válido.");
          this.$router.replace({name: "home"});
        } else if (err && err.code === "ALREADY_ACTIVATED") {
          this.$awn.warning("Su usuario ya fue activado.");
          this.$router.replace({name: "login"});
        } else {
          this.error = genericError;
        }
      });
  },
	methods: {
    submit: function (event) {
      event.preventDefault();
      if (this.user.password !== this.user.confirm) {
        return this.$awn.warning("Las contraseñas no coinciden.");
      }

      const data = {
        token: this.$route.query.token,
        password: this.user.password,
        confirm: this.user.confirm
      };

      this.disabled = true;
      this.$store.dispatch("putActivate", data)
        .then(() => {
          this.$awn.success("¡El usuario se activó correctamente!");
          this.$router.replace({name: "login"});
        }).catch((err) => {
          this.disabled = false;
          if (err && err.code === "WRONG_TOKEN") {
            this.$awn.alert("El código de activación no es válido.");
            this.$router.replace({name: "home"});
          } else if (err && err.code === "ALREADY_ACTIVATED") {
            this.$awn.warning("Su usuario ya fue activado.");
            this.$router.replace({name: "login"});
          } else if (err && err.code === "PASSWORD_MISMATCH") { // Should not reach here.. but it will be validated at the backend anyways!
            this.$awn.warning("Las contraseñas no coinciden.");
          } else if (err && err.code === "PASSWORD_WEAK") {
            this.$awn.warning("La contraseña no cumple con los requerimientos mínimos.");
          } else {
            this.$awn.alert(genericError);
          }
        });
    }
	}
}
</script>
