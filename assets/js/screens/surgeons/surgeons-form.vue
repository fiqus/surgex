<template>
  <div id="surgeons-form">
    <h3 class="subtitle" v-if="loading">Cargando...</h3>
    <div v-if="!loading">
      <h3 v-if="isNew" class="subtitle">Crear cirujano</h3>
      <h3 v-if="!isNew" class="subtitle">Editar cirujano: {{ formatFullName(surgeon) }}</h3>
      <customForm
        :fields="fields"
        :data="surgeon"
        @onSubmit="submit">
      </customForm>
    </div>
  </div>
</template>
<script>
import customForm from "../../components/custom-form";
import {formatFullName} from "../../utils";
export default {
  components: {
		customForm
	},
  data() {
    return {
      surgeon: {},
      loading: true,
      isNew: !Boolean(this.$route.params.surgeonId),
      fields: [
        {key: "first_name", label: "Nombre"},
        {key: "last_name", label: "Apellido"},
        {key: "social_id", label: "DNI"},
        {key: "license", label: "Licencia"},
        {key: "email", label: "Email"},
        {key: "phone", label: "Teléfono"},
        {key: "birthdate", label: "Fecha de Nacimiento", type: "date"},
        {key: "nationality", label: "Nacionalidad"},
        {key: "address", label: "Dirección"},
        {key: "city", label: "Ciudad"},
        {key: "province", label: "Provincia"}
      ],
      formatFullName
    }
	},
  created() {
    if (this.isNew) {
      this.loading = false;
    } else {
      this.$store.dispatch("fetchSurgeon", this.$route.params.surgeonId)
        .then((surgeon) => {
          this.surgeon = surgeon;
          this.loading = false;
        });
    }
  },
	methods: {
    submit: function () {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch(this.isNew ? "createSurgeon" : "updateSurgeon", {component: this, surgeon: this.surgeon, onSuccess});
    }
	}
}
</script>
