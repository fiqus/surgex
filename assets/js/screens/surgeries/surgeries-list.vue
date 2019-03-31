<template>
  <div id="surgeries-list">
    <h3 class="subtitle">Listado de Cirugías</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <button class="button float-right" v-on:click="showNew">
        <i class="fa fa-plus"></i>
        Agregar Cirugía
      </button>
      <table v-if="surgeries.length">
        <thead>
          <th>Fecha</th>
          <th>Cirujano</th>
          <th>Ayudantes</th>
          <th>Paciente</th>
          <th>N° HC</th>
          <th>Diagnóstico</th>
          <th></th>
        </thead>
        <tbody>
          <tr v-for="surgery in surgeries" :key="surgery.id">
            <td><a @click="showDetail(surgery)">{{ surgery.date }}</a></td>
            <td><a @click="showDetail(surgery)">{{ surgery.surgeon.lastName }}, {{ surgery.surgeon.firstName }}</a></td>
            <td>{{ loadAssistants(surgery.assistants) | truncate(25) }}</td>
            <td>{{ surgery.patient.lastName }}, {{ surgery.patient.firstName }}</td>
            <td>{{ surgery.patient.medicalHistory }}</td>
            <td>--</td>
            <td>
              <a @click="showEdit(surgery)">Editar</a>
              |
              <a @click="onDelete(surgery)">Eliminar</a>
            </td>
          </tr>
        </tbody>
      </table>
      <h4 v-if="!surgeries.length">Aún no hay cirugías ingresadas.</h4>
    </div>
  </div>
</template>

<script>
  import CustomTable from "../../components/custom-table";

  export default {
    components: {
      CustomTable
    },
    data() {
      return {
        surgeries: [],
        loading: true
      }
    },
    created() {
      this.$store.dispatch("fetchSurgeries")
        .then((surgeries) => {
          this.surgeries = surgeries;
          this.loading = false;
        });
    },
    methods: {
      loadAssistants(assistants) {
        if (assistants) {
          return assistants.reduce((value, assistant) => {
            if (!value) {
              return `${assistant.lastName}, ${assistant.firstName}`;
            }
            return `${value} - ${assistant.lastName}, ${assistant.firstName}`;
          }, "");
        }
      },
      showNew() {
        this.$router.push({name: "surgeries-new"});
      },
      showDetail(surgery) {
        this.$router.push({name: "surgeries-show", params: {surgeryId: surgery.id}});
      },
      showEdit(surgery) {
        // this.$router.push({name: "surgeries-edit", params: {surgeryId: surgery.id}});
        this.$awn.warning("Próximamente!");
      },
      onDelete(surgery) {
        const onSuccess = () => {
          this.surgeries = this.surgeries.filter((s) => {
            return s.id !== surgery.id;
          });
        };

        this.$store.dispatch("deleteSurgery", {component: this, surgery, onSuccess});
      }
    },
    filters: {
      truncate: function(value, limit) {
        if (value && value.length > limit) {
          return value.substring(0, (limit - 3)) + '...';
        }
        return value;
      }
    }
  }
</script>