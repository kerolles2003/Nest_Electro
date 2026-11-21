/** Scoped P1 contract update from compiled Swagger metadata; never boots AppModule.
 * Full application drift certification still requires the owned test database.
 * Run after `nest build`; --check reads and compares without writing.
 */
require('reflect-metadata');
const fs = require('node:fs');
const path = require('node:path');
const swaggerPath = path.dirname(require.resolve('@nestjs/swagger'));
const { SchemaObjectFactory } = require(swaggerPath + '/services/schema-object-factory');
const { ModelPropertiesAccessor } = require(swaggerPath + '/services/model-properties-accessor');
const { SwaggerTypesMapper } = require(swaggerPath + '/services/swagger-types-mapper');
const { DECORATORS } = require(swaggerPath + '/constants');
const { AdminProductDto } = require('../dist/modules/catalog/presentation/dto/admin-product-response.dto');
const { ArrangeImagesDto, HardDeleteResultDto } = require('../dist/modules/catalog/presentation/dto/admin-product-image.dto');
const { UnreferencedAssetDto } = require('../dist/modules/media/presentation/dto/media-response.dto');
const { AdminProductsController } = require('../dist/modules/catalog/presentation/admin-products.controller');
const { AuditAction } = require('../dist/modules/audit/domain/audit-action');

const filename = path.resolve(__dirname, '../../../docs/api/openapi.v1.json');
const original = fs.readFileSync(filename, 'utf8');
const document = JSON.parse(original);
const schemas = {};
const factory = new SchemaObjectFactory(new ModelPropertiesAccessor(), new SwaggerTypesMapper());
for (const dto of [AdminProductDto, ArrangeImagesDto, HardDeleteResultDto, UnreferencedAssetDto]) {
  factory.exploreModelSchema(dto, schemas);
  document.components.schemas[dto.name] = schemas[dto.name];
}
let operationsUpdated = 0;
for (const route of Object.values(document.paths)) {
  for (const operation of Object.values(route)) {
    if (operation?.operationId === 'AdminProductsController_hardDelete_v1') {
      operationsUpdated++;
      const metadata = Reflect.getMetadata(DECORATORS.API_OPERATION, AdminProductsController.prototype.hardDelete);
      operation.summary = metadata.summary;
      operation.description = metadata.description;
    }
    if (operation?.operationId === 'AdminProductsController_arrangeImages_v1') {
      operationsUpdated++;
      const metadata = Reflect.getMetadata(DECORATORS.API_RESPONSE, AdminProductsController.prototype.arrangeImages);
      operation.responses['409'].description = metadata['409'].description;
    }
  }
}
if (operationsUpdated !== 2) throw new Error('Expected both P1 operation IDs in the contract.');
function updateAuditEnums(value) {
  if (!value || typeof value !== 'object') return;
  if (Array.isArray(value.enum) && value.enum.includes('USER_ROLE_CHANGED') && value.enum.includes('PRODUCT_CREATED')) {
    value.enum = Object.values(AuditAction);
  }
  for (const child of Object.values(value)) updateAuditEnums(child);
}
updateAuditEnums(document);
const updated = JSON.stringify(document, null, 2) + '\n';
if (process.argv.includes('--check')) {
  if (updated !== original) throw new Error('P1 Swagger metadata differs from the contract artifact.');
  console.log('P1 contract metadata matches. No database or provider accessed.');
} else {
  fs.writeFileSync(filename, updated);
  console.log('Updated only P1 schemas, action enums and operation descriptions.');
}
