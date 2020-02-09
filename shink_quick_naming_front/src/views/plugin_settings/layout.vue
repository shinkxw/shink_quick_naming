<template>
  <div class="adaptive_height_dlg" style="width: 100%;height: 670px;position: relative;">
    <div class="left_bar" onselectstart="return false;">
      <div class="list-group type_list" style="margin-top: 20px;">
        <a v-for="type in type_arr" class="list-group-item"
           :class="{active: choosed_type == type}" @click="choose_type(type)">
          {{type.name}}
        </a>
      </div>
    </div>
    <div class="right_bar" @click.stop="">
      <router-view></router-view>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        type_arr: [{name: '图层设置', path: 'layer_setting'},
                   {name: '命名设置', path: 'naming_setting'}],
        choosed_type: null
      }
    },
    created() {
      this.choose_type(this.type_arr[0])
      this.$nextTick(() => { cal_and_set_css() })
    },
    methods: {
      choose_type(type){
        this.choosed_type = type
        this.$router.push({ path: '/plugin_settings/' + type.path })
      }
    }
  }
</script>

<style scoped>
  .left_bar{
    width: 95px;
    height: 100%;
    background-color: #e2e2e2;
    color: #333;
    position: absolute;
    z-index: 10;
    padding-bottom: 90px;
  }
  .right_bar{
    padding-left: 95px;
    min-height: 620px;
    box-sizing: border-box;
    position: absolute;
    left: 0;
    right: 0;
    overflow-x: hidden;
    overflow-y: auto;
    background-color: #fff;
  }
  .type_list a{
    cursor: pointer;
  }
</style>
