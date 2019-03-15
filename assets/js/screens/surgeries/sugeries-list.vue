<template>
  <div>
    <h3 class="subtitle">Listado de Cirugías</h3>
    <button class="button float-right" v-on:click="addSurgery">
      <i class="fa fa-plus"></i>
      Agregar Cirugía
    </button>
    <h4 v-if="!surgeries.length">Aún no tiene cirugías cargadas</h4>
    <table v-if="surgeries.length">
      <thead>
        <th>Fecha</th>
        <th>Cirujano</th>
        <th>Ayudantes</th>
        <th>N° HC</th>
        <th>Paciente</th>
        <th>Diagnóstico</th>
        <th></th>
      </thead>
      <tbody>
        <tr v-for="surgery in surgeries" :key="surgery.id">
          <td>{{ surgery.date }}</td>
          <td>{{ surgery.surgeon.lastName }}, {{ surgery.surgeon.firstName }}</td>
          <td>{{ loadAssistants(surgery.assistants) | truncate(25) }}</td>
          <td>--</td>
          <td>{{ surgery.patient.last_name }}, {{ surgery.patient.first_name }}</td>
          <td>--</td>
          <td>
            <a @click="onDelete(surgery)" title="Eliminar"><i class="fa fa-trash"></i></a>
          </td>
        </tr>
      </tbody>
    </table>
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
      },
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
      onDelete(surgery) {
        const onSuccess = () => {
          return this.$store.dispatch("fetchSurgeries");
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