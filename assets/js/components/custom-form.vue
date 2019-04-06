<template>
  <div>
		<form class="form-custom" :class="params.class" v-on:submit.prevent="onSubmit">
			<div class="form-field-container" v-for="field in fields" :key="field.key">
				<label>{{field.label}}:</label>
				<select v-if="field.type === 'select'" :disabled="field.disabled" :placeholder="field.placeholder" v-model="data[field.key]">
					<option value="">-</option>
					<option v-for="option in field.options" :key="option.key" :value="option.key">{{option.value}}</option>
				</select>
				<input v-else :type="field.type || 'text'" :disabled="field.disabled" :placeholder="field.placeholder" v-model="data[field.key]">
			</div>
			<div class="action-bar-buttons">
				<button type="button" class="btn btn-secondary" @click.stop="$router.go(-1)"><i class="fa fa-arrow-left"></i> Cancelar</button>
				<button type="submit" class="btn btn-success"><i class="fa fa-save"></i> Guardar</button>
			</div>
		</form>
		
  </div>
</template>
<script>
const params = {
	class: ""
};

export default {
  props: {
		fields: {
			type: Array,
			required: false,
			default: []
		},
		data: {
      type: Object,
      required: true,
      default: () => {}
		},
		params: {
      type: Object,
      required: false,
      default: () => params
    }
  },
  data() {
    return {};
  },
  methods: {
		onSubmit(elem) {
      this.$emit("onSubmit", this.data);
    }
  }
}
</script>
