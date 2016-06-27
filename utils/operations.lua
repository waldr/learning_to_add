--[[
  Copyright 2014 Google Inc. All Rights Reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
]]--


--function add_opr(hardness)
--  local a, b = get_operands(hardness, 2)
--  eval = a.eval + b.eval
--  expr = string.format("(%s+%s)", a.expr, b.expr)
--  return {}, expr, eval
--end

function zero_pad_int(i, n)
  return string.format(string.format("%%0%dd", n), i) 
end

function get_carry_free_int(s)
  r = 0
  for i = 1, #s do
    c = string.sub(s, i, i)
    if c == '9' then
      r = r * 10
    else 
      r = r * 10 + (random('9' - c + 1) - 1)
    end
  end
  return r
end

function add_opr(hardness)

  local hard_a = hardness()
  local hard_b = hardness()
  if add_nocarry then
    hard_b = hard_a
  end
  local hardest = math.max(hard_a, hard_b)

  local a_str, a = get_operand(hard_a)
  local b = 0
  local b_str = ""
  
  if add_nocarry then
    b = get_carry_free_int(zero_pad_int(a, hard_a))
  else
    b_str, b = get_operand(hard_b)
  end
  eval = a + b
  
  if add_padded then
    a_str = zero_pad_int(a, hardest)
    b_str = zero_pad_int(b, hardest)
  else
    a_str = string.format("%d", a)
    b_str = string.format("%d", b)
  end

  if add_inverted then
    a_str = string.reverse(a_str)
    b_str = string.reverse(b_str)
  end

  expr = string.format("%s+%s", a_str, b_str)
  return {}, expr, eval
end


--function pair_opr(hardness)
--  local a, b = get_operands(hardness, 2)
--  if random(2) == 1 then
--    eval = a.eval + b.eval
--    expr = string.format("(%s+%s)", a.expr, b.expr)
--  else
--    eval = a.eval - b.eval
--    expr = string.format("(%s-%s)", a.expr, b.expr)
--  end
--  return {}, expr, eval
--end
--
--
--function smallmul_opr(hardness)
--  local expr, eval = get_operand(hardness)
--  local b = random(4 * hardness())
--  local eval = eval * b
--  if random(2) == 1 then
--    expr = string.format("(%s*%d)", expr, b)
--  else
--    expr = string.format("(%d*%s)", b, expr)
--  end
--  return {}, expr, eval
--end
--
--function equality_opr(hardness)
--  local expr, eval = get_operand(hardness)
--  return {}, expr, eval
--end
--
--function vars_opr(hardness)
--  local var = variablesManager:get_unused_variables(1)
--  local a, b = get_operands(hardness, 2)
--  if random(2) == 1 then
--    eval = a.eval + b.eval
--    code = {string.format("%s=%s;", var, a.expr)}
--    expr = string.format("(%s+%s)", var, b.expr)
--  else
--    eval = a.eval - b.eval
--    code = {string.format("%s=%s;", var, a.expr)}
--    expr = string.format("(%s-%s)", var, b.expr)
--  end
--  return code, expr, eval
--end
--
--
--function small_loop_opr(hardness)
--  local r_small = hardness()
--  local var = variablesManager:get_unused_variables(1)
--  local a, b = get_operands(hardness, 2)
--  local loop = random(4 * hardness())
--  local op = ""
--  local val = 0
--  if random(2) == 2 then
--    op = "+"
--    eval = a.eval + loop * b.eval
--  else
--    op = "-"
--    eval = a.eval - loop * b.eval
--  end
--  local code = {string.format("%s=%s", var, a.expr),
--                string.format("for x in range(%d):%s%s=%s", loop, var,
--                                                            op, b.expr, var)}
--  local expr = var
--  return code, expr, eval
--end
--
--function ifstat_opr(hardness)
--  local r_small = hardness()
--  local a, b, c, d = get_operands(hardness, 4)
--  if random(2) == 1 then
--    name = ">"
--    if a.eval > b.eval then
--      output = c.eval
--    else
--      output = d.eval
--    end
--  else
--    name = "<"
--    if a.eval < b.eval then
--      output = c.eval
--    else
--      output = d.eval
--    end
--  end
--  local expr = string.format("(%s if %s%s%s else %s)",
--                             c.expr, a.expr, name, b.expr, d.expr)
--  return {}, expr, output
--end
--
