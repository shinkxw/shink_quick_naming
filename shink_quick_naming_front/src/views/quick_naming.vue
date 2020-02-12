<template>
  <div class="adaptive_height_dlg" style="width: 100%;height: 870px;position: relative;">
    <div class="top_box">
      <div class="attr_row" v-if="entity_info">
        <div class="attr_value layer_name">
          图层:
          {{entity_info.layer_name}}
        </div>
        <div class="attr_value">
          名称:
          <input type="text" @input="change_name" v-model="entity_info.name">
        </div>
        <div class="btn btn-default clear_btn" @click.stop="clear_layer">图层归零</div>
      </div>
      <div v-else>请选择一个组件/群组</div>
    </div>
    <div class="left_bar" onselectstart="return false;">
      <div class="list-group mc_list">
        <a v-for="mc in setting_data" class="list-group-item"
           :class="{active: choosed_mc == mc}" @click="choose_mc(mc)">
          {{mc.name}}
        </a>
      </div>
      <div class="list-group sc_list" style="height:610px;overflow-y: auto;">
        <a v-for="sc in sc_arr" class="list-group-item"
           :class="{active: choosed_sc == sc}" @click="choosed_sc = sc">
          {{sc.name}}
        </a>
      </div>
    </div>
    <div class="right_bar" @click.stop="">
      <div style="height:610px;overflow-y: auto;">
        <div class="btn btn-default add_btn" v-for="data in data_arr"
          @click="set_name_and_layer(data)">{{data.name}}</div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        setting_data: [],
        choosed_mc: null,
        choosed_sc: null,
        entity_info: null
      }
    },
    created() {
      window.quick_naming = this
      this.refresh_setting_data()
      this.refresh_entity_info()
    },
    computed: {
      sc_arr() {
        if (this.choosed_mc && this.choosed_mc.c_arr) {
          return this.choosed_mc.c_arr
        }
        return []
      },
      current_category() {
        return this.choosed_sc ? this.choosed_sc : this.choosed_mc
      },
      data_arr() {
        if (this.current_category && this.current_category.d_arr.length > 0) {
          return this.current_category.d_arr
        }
        else{
          return []
        }
      }
    },
    methods: {
      choose_mc(mc) {
        if (this.choosed_mc != mc) {
          this.choosed_mc = mc
          this.choosed_sc = null
        }
        this.choosed_sc = null
      },
      set_name_and_layer(data) {
        var params = {name: data.name, layer_id: data.layer_id}
        su_location('set_current_entity_name_and_layer', params)
      },
      change_name() {
        var params = {name: this.entity_info.name, layer_id: null}
        su_location('set_current_entity_name_and_layer', params)
      },
      clear_layer() {
        var params = {name: this.entity_info.name, layer_id: 'Layer0'}
        su_location('set_current_entity_name_and_layer', params)
      },
      refresh_entity_info() {
        axios.get('/get_current_entity_layer_info')
          .then((res) => {
            if (res && res.data) {
              this.entity_info = res.data
            }
            else{
              this.entity_info = null
            }
          })
      },
      refresh_setting_data() {
        udoi('naming_setting', 'data', {}, (data) => {
          this.setting_data = data
          this.$nextTick(() => { cal_and_set_css() })
        })
      },
    }
  }
</script>

<style scoped>
  .left_bar{
    width: 260px;
    height: 100%;
    background-color: #f2f2f2;
    color: #333;
    position: absolute;
    z-index: 10;
    padding-bottom: 90px;
  }
  .right_bar{
    padding-left: 268px;
    padding-top: 10px;
    padding-bottom: 10px;
    height: 100%;
    min-height: 670px;
    box-sizing: border-box;
    position: absolute;
    left: 0;
    right: 0;
    overflow-x: hidden;
    overflow-y: auto;
    background-color: rgb(240, 240, 240);
  }
  .mc_list{
    width: 102px;
    position: absolute;
    z-index: 15;
  }
  .sc_list{
    width: 260px;
    padding-left: 103px;
    position: absolute;
    z-index: 10;
  }
  .list-group a{
    cursor: pointer;
  }
  .top_box{
    padding-left: 10px;
    padding-top: 5px;
    padding-bottom: 8px;
    background-color: rgb(198, 198, 198);
  }
  .btn_box{
    padding-top: 2px;
    padding-bottom: 4px;
    border-bottom: 1px solid #ddd;
  }
  .add_btn{
    padding-top: 3px;
    padding-bottom: 3px;
    padding-left: 8px;
    padding-right: 8px;
    margin-right: 3px;
    margin-top: 2px;
  }
  .clear_btn{
    float: right;
    padding-top: 2px;
    padding-bottom: 2px;
    padding-left: 5px;
    padding-right: 5px;
    margin-right: 10px;
    margin-top: -1px;
  }
  .attr_row{
    padding-top: 2px;
  }
  .attr_value{
    margin-left: 10px;
    display: inline-block;
  }
  .attr_value > input[type="text"], textarea{
    width: 150px;
  }
  .layer_name{
    text-overflow: ellipsis;
    white-space: nowrap;
    width: 45%
  }
</style>
