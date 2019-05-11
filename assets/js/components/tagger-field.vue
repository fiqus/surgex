<template>
  <div class="form-row tagger-field">
    <div class="col-md-5">
      <select class="form-control" v-model="selected">
        <option v-if="firstOption" value="">{{firstOption}}</option>
        <option v-for="option in values" :key="option.key" :value="option.key">{{option.value}}</option>
      </select>
    </div>
    <div class="col-md-1">
      <button type="button" :disabled="!selected" v-on:click.stop="onAdd" class="button"><i class="fa fa-plus"></i></button>
    </div>

    <div class="col-md-5" v-if="tags.length > 0" style="width: calc(100% - 63px);">
      <label>Seleccionado:</label>
      <li v-for="tag in tags" :key="tag.key">
        {{tag.value}} <i class="fa fa-trash remove-tag" title="Quitar" v-on:click="onRemove(tag)"></i>
      </li>
    </div>
  </div>
</template>
<script>
  export default {
    props: ["options", "firstOption", "value"],
    data() {
      return {
        selected: ""
      }
    },
    computed: {
      values: {
        get() {
          // Remove already selected values
          const options = this.options.filter(({key}) => !this.value.find(({id}) => key === id));
          if (!options.find(o => o.key === this.selected)) {
            this.selected  = ""; // Remove current selected value as is not part of given options
          }
          
          return options;
        }
      },
      tags: {
        get() {
          return (this.value || []).reduce((tags, val) => {
            const item = this.options.find(opt => opt.key === val.id);
            return item ? tags.concat(item) : tags;
          }, []);
        }
      }
    },
    methods: {
      onAdd() {
        if (this.selected) {
          this.value.push({id: this.selected});
          this.$emit("input", this.value);
        }
      },
      onRemove(tag) {
        const values = this.value.filter(({id}) => id !== tag.key);
        this.$emit("input", values);
      }
    }
  }
</script>
<style>
.tagger-field .remove-tag {
  cursor: pointer;
  color: red;
}
</style>
