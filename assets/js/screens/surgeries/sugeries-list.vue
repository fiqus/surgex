<template>
  <div>
    <h3 class="subtitle">Listado de Cirugías</h3>
    <button class="button float-right" v-on:click="addSurgery">
      <i class="fa fa-plus"></i>
      Agregar Cirugía
    </button>
    <div class="center">
      <h4 v-if="!surgeries.length">Aún no tiene cirugías cargadas</h4>
      <custom-table
        v-if="surgeries.length"
        :headers="columns"
        :data="surgeries">
      </custom-table>
    </div>
  </div>
</template>

<script>
  import CustomTable from "../../components/custom-table";

  export default {
    components: {
      CustomTable
    },
    created() {
      return this.$store.dispatch("fetchSurgeries");
    },
    computed: {
      surgeries: {
        get() {
          return this.$store.state.surgeries;
        }
      }
    },
    methods: {
      addSurgery() {
        this.$router.push({name: "surgery-new"});
      }
    },
    data() {
      return {
        columns: [
          {key: "fecha", value: "Fecha"},
          {key: "hclinica", value: "N° HC"},
          {key: "diagnostico", value: "Diagnóstico"},
          {key: "cirujano", value: "Cirujano"},
          {key: "ayudante", value: "Ayudante"},
          {key: "paciente", value: "Paciente"}
        ]
      }
    }
  }
</script>