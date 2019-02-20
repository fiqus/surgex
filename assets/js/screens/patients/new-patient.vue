<template>
  <div>
    <customForm
     :formName="'Nuevo Paciente'"
     :fields="this.fields"
     @create="newPatient">
    </customForm>
    <button v-on:click="backToList" class="button">
      <i class="fa fa-caret-left"></i>
      Volver al listado
    </button>
  </div>
</template>
<script>
import customForm from "../../components/custom-form";
export default {
	components: {
		customForm
	},
  data() {
    return {
      fields: [
        {key: "first_name", placeholder: "Nombre"},
        {key: "last_name", placeholder: "Apellido"},
        {key: "medical_history", placeholder: "Historia Clínica"}, 
        {key: "address", placeholder: "Dirección"},
        {key: "city", placeholder: "Ciudad"},
        {key: "province", placeholder: "Provincia"},
        {key: "birthdate", type: "date"}
      ]
    }
  },
  computed: {
  },
  methods: {
    backToList() {
      this.$router.push({name: "patients-list"});
    },
    newPatient: function(payload) {
      this.$store.dispatch("createPatient", {component: this, data: JSON.stringify({patient: payload}), onSuccess: this.backToList})
    }
  },
}
</script>
