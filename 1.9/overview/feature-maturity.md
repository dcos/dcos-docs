---
post_title: Feature Maturity
menu_order: 10
---

The purpose of the feature maturity phases is to educate customers, partners, and Mesosphere field and support organizations about the maturity and quality of features.

- [Criteria](#criteria)
- [Phases](#phases)

# <a name="criteria"></a>Criteria

## Completeness

**Functionality:** Completeness of the feature implementation.

**Interfaces:** Feature has an API with deprecation cycle, CLI, and UI.

**Documentation:** Feature has appropriate documentation. e.g., Admin Guide, Developer Guide, Release Notes.

## Quality

**Functional Test:** Feature is validated for correctness.

**System Test:** Feature is validated to meet scalability, reliability, and performance requirements through a combination of load, soak, stress, spike, fault, and configuration tests.

**Mesosphere Dogfooding:** Feature in-use in Mesosphere production environment.

# <a name="phases"></a>Phases

## <a name="experimental"></a>Experimental

Use these features at your own risk. We might add, change, or delete any functionality.

### Completeness

* Feature may be incomplete
* API may be incomplete and is subject to change without warning or deprecation cycle
* User interfaces may be missing or incomplete
* Documentation may be missing or incomplete

### Quality

* Limited or no functional test
* Limited or no system test
* Limited or no Mesosphere dogfooding

## <a name="preview"></a>Preview

We might add, change, or delete any functionality.

### Completeness

* Feature is complete
* API may be incomplete and changes may not be subject to deprecation cycle
* User interfaces may be missing or incomplete
* Documentation may be incomplete

### Quality

* Robust functional test
* Limited or no system test
* Limited or no Mesosphere dogfooding

## <a name="stable"></a>Stable

### Completeness

* Feature is complete
* API is complete and changes are subject to deprecation cycle
* User Interfaces are complete
* Documentation is complete

### Quality

* Robust functional test
* Robust performance testing
* Robust fault testing
* Robust Mesosphere dogfooding


