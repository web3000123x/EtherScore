<template>
    <v-row class="text-center" justify="center">
  <v-card
    elevation="15"
    style="max-width:700px; max-height: 800px; border-radius: 20px;
    padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
    opacity: 0.95;"
    class="pa-10 mt-15"
  >

    <v-row>
      <h1 class="display-2 black--text ma-3">
        Create new Badge Definition
      </h1>
      <br/>
      <p class="subheading font-weight-regular black--text ma-2">
        No-code NFT badge model issuing
      </p>
    </v-row>
        <template>
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >

            <v-row>
              <v-col cols="4">
                <v-subheader>Badge Name</v-subheader>
              </v-col>
              <v-col cols="8">
                <v-text-field
                  v-model="name"
                  :rules="nameRules"
                  label="Badge Name"
                  required
                  outlined
                  shaped
                  class="mb-n6"
                  :hint="hintName"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="4">
                <v-subheader>Description</v-subheader>
              </v-col>
              <v-col cols="8">
                  <v-textarea
                    label="Description"
                    auto-grow
                    outlined
                    rows="3"
                    row-height="25"
                    shaped
                    class="mb-n12"
                    :hint="hintDescription"
                  ></v-textarea>
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="4">
                <v-subheader>Image</v-subheader>
              </v-col>
              <v-col cols="8">
                <v-file-input
                  accept="image/png, image/jpeg, image/bmp"
                  placeholder="Pick an image"
                  prepend-icon="mdi-camera"
                  class="mt-0"
                  label="Image"
                ></v-file-input>
              </v-col>
            </v-row>

            <v-divider/>

            <p class="subheading font-weight-regular black--text ma-2" align="left"> 
              NFT minting conditions 
            </p>
            <v-row>
                <v-select
                  v-model="protocol"
                  :items="protocols"
                  :rules="[v => !!v || 'Protocol is required']"
                  label="Protocol"
                  required
                  outlined
                  shaped
                  class="mt-5"
                  dense
                  style="max-width:300px;"
                  :hint="hintProtocol"
                ></v-select>
                <v-spacer/>
                <v-select
                  v-model="indexer"
                  :items="indexers"
                  :rules="[v => !!v || 'Protocol is required']"
                  label="Indexer"
                  required
                  outlined
                  shaped
                  class="mt-5"
                  dense
                  style="max-width:300px;"
                  :hint="hintIndexer"
                ></v-select>
            </v-row>

            <v-row>
              <v-select
                v-model="metric"
                :items="metrics"
                :rules="[v => !!v || 'Metric is required']"
                label="Metric"
                required
                outlined
                shaped
                dense
                style="max-width:200px;"
                :hint="hintMetric"
              ></v-select>
                <v-spacer/>
              <v-select
                v-model="operator"
                :items="operators"
                :rules="[v => !!v || 'Operator is required']"
                label="Operator"
                required
                outlined
                shaped
                dense
                style="max-width:150px;"
                :hint="hintOperator"
              ></v-select>
              <v-spacer/>
              <v-text-field
                v-model="value"
                label="Value"
                :rules="[v => !!v || 'Value is required']"
                required
                outlined
                shaped
                dense
                style="max-width:100px;"
                :hint="hintValue"
              ></v-text-field>
              <v-spacer/>
              <v-btn
                class="ma-3"
                dark
                color="indigo"
                @click="updateConditions"
              >
              <v-icon dark>
                mdi-plus
              </v-icon>
              Add condition
            </v-btn>            
            </v-row>
            <div class="green--text ma-1" v-if="showConditions" align="left">
              The badge will be claimable to users of : <br/>
              <p v-for="condition in conditions" :key="condition.protocol">
               {{ condition[0] }} having {{ condition[1] }} {{ condition[2] }} {{ condition[3] }}
              </p>
            </div>

            <v-switch
              v-model="checkbox2"
              label="NFT transfer authorized"
              required
              color="indigo"
            ></v-switch>

            <v-btn
              :disabled="!valid"
              color="success"
              class="mr-4"
              @click="validate"
            >
              Deploy Badge Model
            </v-btn>
          </v-form>
        </template>
    <v-spacer></v-spacer>
  </v-card>
    </v-row>
</template>

<script>

  export default {
    name: 'BadgeFactory',
    data: () => ({
      valid: true,
      name: '',
      descritption: '',
      value: '',
      protocol: '',
      metric: '',
      indexer: '',
      operator: '',
      conditions: [],
      nameRules: [
        v => !!v || 'Badge Name is required',
        v => (v && v.length <= 10) || 'Badge Name must be less than 10 characters',
      ],
      select: null,
      protocols: [
        'Uniswap',
        'Compound',
        'Aave',
      ],
      metrics: [
        'Number of swap',
        'Gas consumed'
      ],
      indexers: [
        'The Graph Protocol',
        'Covalent',
      ],
      operators: [
        '==',
        '=>',
        '<=',
      ],
      checkbox2: true,
      hintName: "The name of your badge (example: \"Uniswapper boy\")",
      hintDescription: "The description of your badge (example: \"The best badge ever\")",
      hintProtocol: "Users that interact with",
      hintIndexer: "The data source used as Oracle",
      hintMetric: "The metric concerned by the condition",
      hintOperator: "The operator such as equal, greater/less than",
      hintValue: "The number ....",
      showConditions: false,
    }),

    methods: {
      validate () {
        this.$refs.form.validate()
      },
      updateConditions () {
        if (this.$refs.form.validate()) {
          this.showConditions = true
          this.conditions.push([this.protocol, this.metric, this.operator,this.value])
        }
      }
    },
  }
</script>