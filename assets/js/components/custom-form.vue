<template>
  <div>
		<h3 class="subtitle">{{formName}} </h3>
    <form>
			<div v-for="(field, index) in fields" :key="index">
				<input :type="field.type || 'text'" :placeholder="field.placeholder" v-model="data[field.key]">
			</div>
			<button class="button" v-on:click="sendData">Guardar</button>
		</form>
  </div>
</template>
<script>
export default {
	created() {
    this.data = this.manualData || {}
  },
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
		},
		manualData: {
			type: Object,
			required: false,
			default: null
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
