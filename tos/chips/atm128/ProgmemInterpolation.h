/**
 * @author Raido Pahtma
 * @license MIT
 *
 * Interpolation function for two-column float table stored in PROGMEM.
*/
#ifndef PROGMEM_INTERPOLATION_H_
#define PROGMEM_INTERPOLATION_H_

/**
 * progmem_interpolate - interpolate value from table stored in PROGMEM. From column one to column two.
 *
 * @param resistance - input value to search for in the first column of the table.
 * @param table - table to use for interpolation, two columns.
 * @param table_rows - number of rows in the table.
 * @param nc - Negative coefficient, TRUE if values in first column decrease as values in second increase,
 *             i.e. TRUE for NTC thermistors and FALSE for PTC thermistors.
 * @return - interpolated value
 */
float progmem_interpolate(float resistance, const float table[][2], uint8_t table_rows, bool nc) @C();

// const float example_negative_coefficient_table[5][2] PROGMEM = {
//    {  4200.00, -10 },
//    {  3400.00,  -5 },
//    {  2700.00,   0 },
//    {  2200.00,   5 },
//    {  1700.00,  10 }
// };

// const float example_positive_coefficient_table[5][2] PROGMEM = {
//    {  1700.00, -10 },
//    {  2200.00,  -5 },
//    {  2700.00,   0 },
//    {  3400.00,   5 },
//    {  4200.00,  10 }
// };

#endif // PROGMEM_INTERPOLATION_H_
