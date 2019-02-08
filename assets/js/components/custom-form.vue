<template>
  <div>
		<h3 class="subtitle">Nuevo {{formName}} </h3>
    <form>
			<div v-for="field in fields">
				<input :type="field.type || 'text'" :placeholder="field.placeholder" v-model="data[field.key]">
			</div>
			<button class="button" v-on:click="sendData">Crear</button>
		</form>
  </div>
</template>
<script>
export default {
  props: {
		formName: {
			type: String,
			required: true,
			default: ""
		},
		fields: {
			type: Array,
			required: false,
			default: []
		}
  },
  data() {
    return {
			data: {}
    }
  },
  methods: {
		sendData() {
			this.$emit("create", this.data);
		}
  }
}
</script>
