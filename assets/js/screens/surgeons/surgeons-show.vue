<template>
  <div id="surgeons-show">
    <h3 class="subtitle">Detalle del Cirujano</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Cirujano:</b> {{formatFullName(surgeon)}}</div>
        <div><b>DNI:</b> {{surgeon.socialId || "-"}}</div>
        <div><b>Licencia:</b> {{surgeon.license || "-"}}</div>
        <div><b>Email:</b> {{surgeon.email}}</div>
        <div><b>Teléfono:</b> {{surgeon.phone || "-"}}</div>
        <div><b>Fecha Nacimiento:</b> {{formatDate(surgeon.birthdate, {time: false})}}</div>
        <div><b>Nacionalidad:</b> {{surgeon.nationality || "-"}}</div>
        <div><b>Dirección:</b> {{surgeon.address || "-"}}</div>
        <div><b>Ciudad:</b> {{surgeon.city || "-"}}</div>
        <div><b>Provincia:</b> {{surgeon.province || "-"}}</div>
      </section>
      <div class="action-bar-buttons">
        <button class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Volver</button>
        <button class="btn btn-primary" @click.stop="showEdit(surgeon)" v-if="isAdmin"><i class="fa fa-edit"></i> Editar</button>
        <button class="btn btn-danger" @click.stop="onDelete(surgeon)" v-if="isAdmin"><i class="fa fa-trash"></i> Eliminar</button>
      </div>
    </div>
  </div>
</template>
<script>
import {formatDate, formatFullName} from "../../utils";
export default {
  data() {
    return {
      surgeon: null,
      loading: true,
      formatDate,
      formatFullName
    }
  },
  created() {
    this.$store.dispatch("fetchSurgeon", this.$route.params.surgeonId)
      .then((surgeon) => {
        this.surgeon = surgeon;
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
    showEdit(surgeon) {
      this.$router.push({name: "surgeons-edit", params: {surgeonId: surgeon.id}});
    },
    onDelete(surgeon) {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("deleteSurgeon", {component: this, surgeon, onSuccess});
    }
  }
}
</script>
