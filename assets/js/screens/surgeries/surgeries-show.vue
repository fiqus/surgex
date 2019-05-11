<template>
  <div id="surgeries-show">
    <h3 class="subtitle">Detalle de la Cirugía</h3>
    <div v-if="loading">Cargando...</div>
    <div v-if="!loading">
      <section class="elem-details">
        <div><b>Fecha:</b> {{formatDate(surgery.date, {time: false})}}</div>
        <div><b>Cirujano:</b> {{formatFullName(surgery.surgeon)}}</div>
        <div><b>Ayudantes:</b> <span v-html="assistants"></span></div>
        <div><b>Paciente:</b> {{formatFullName(surgery.patient)}}</div>
        <div><b>Historia Clínica:</b> {{surgery.patient.medical_history || "-"}}</div>
        <div><b>Diagnóstico:</b> {{surgery.diagnostic ? `${surgery.diagnostic.name} :: ${surgery.diagnostic.description}` : "-"}}</div>
        <div><b>Comentarios:</b> {{surgery.comments || "-"}}</div>
        <div><b>Fotos:</b> {{(surgery.photos || []).length || "-"}}</div>
        <div v-if="photoSelected" class="open-photo" v-on:click="closePhoto">
          <span class="close" title="Cerrar" v-on:click="closePhoto">&times;</span>
          <img class="open-photo-content" :src="photoSelected">
        </div>
        <div class="row text-center text-lg-left">
          <div class="col-lg-3 col-md-4 col-6" v-for="photo in surgery.photos" :key="photo.id">
            <div class="card" style="width: 300px; height: 300px;">
              <img class="img-thumbnail photo-thumbnail" title="Ver en tamaño original" :src="photoUrl(photo)" v-on:click="openPhoto(photoUrl(photo))"/>
              <div class="card-body">
                <span class="d-inline-block text-truncate photo-name align-middle" style="max-width:260px" :title="photo.name">
                  {{photo.name}}
                </span>
              </div>
            </div>
          </div>
        </div>
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
      assistants: "",
      photoSelected: null,
      loading: true,
      formatDate,
      formatFullName
    }
  },
  mounted() {
    window.addEventListener("keyup", (e) => {
      if (e.key === "Escape") {
        this.closePhoto();
      }
    });
  },
  created() {
    this.$store.dispatch("fetchSurgery", this.$route.params.surgeryId)
      .then((surgery) => {
        this.surgery = surgery;
        this.assistants = surgery.assistants.map(formatFullName).join(" / ") || "-";
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
    photoUrl(photo) {
      return `${this.$store.getters.getSurgeriesPhotosPath}${photo.name}`;
    },
    openPhoto(photo) {
      this.photoSelected = photo;
    },
    closePhoto() {
      this.photoSelected = null;
    },
    showEdit(surgery) {
      this.$router.push({name: "surgeries-edit", params: {surgeryId: surgery.id}});
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
