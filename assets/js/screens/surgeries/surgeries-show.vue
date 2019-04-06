<template>
  <div id="surgeries-show">
    <h3 class="subtitle">Detalle de la Cirugía</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Cirujano:</b> {{formatFullName(surgery.surgeon)}}</div>
        <div><b>Paciente:</b> {{formatFullName(surgery.patient)}}</div>
        <div><b>Fecha:</b> {{formatDate(surgery.date, {time: false})}}</div>
      </section>
      <div class="action-bar-buttons">
        <button class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Volver</button>
        <button class="btn btn-primary" @click.stop="showEdit(surgery)" v-if="isAdmin"><i class="fa fa-edit"></i> Editar</button>
        <button class="btn btn-danger" @click.stop="onDelete(surgery)" v-if="isAdmin"><i class="fa fa-trash"></i> Eliminar</button>
      </div>
    </div>
  </div>
</template>
<script>
import {formatDate, formatFullName} from "../../utils";
export default {
  data() {
    return {
      surgery: null,
      loading: true,
      formatDate,
      formatFullName
    }
  },
  created() {
    this.$store.dispatch("fetchSurgery", this.$route.params.surgeryId)
      .then((surgery) => {
        this.surgery = surgery;
        this.loading = false;
      });
  },
  computed: {
    isAdmin: {
      get() {
        return this.$store.getters.isAdmin;
      }
    }
  },
  methods: {
    showEdit(surgery) {
      // this.$router.push({name: "surgeries-edit", params: {surgeryId: surgery.id}});
      this.$awn.warning("Próximamente!");
    },
    onDelete(surgery) {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("deleteSurgery", {component: this, surgery, onSuccess});
    }
  }
}
</script>
