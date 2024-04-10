using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapGenerator.Models
{
    public static class MapDataExtensions
    {
        public static Dictionary<string, bool> FilterFalse(this Dictionary<int, bool> dic)
        {
            Dictionary<string, bool> tmp = new Dictionary<string, bool>();
            foreach (KeyValuePair<int, bool> pair in dic)
            {
                if (pair.Value)
                {
                    tmp.Add("block_" + pair.Key, true);
                }
            }
            return tmp;
        }

        public static Dictionary<string, string> FilterNull(this Dictionary<int, int?> dic)
        {
            Dictionary<string, string> tmp = new Dictionary<string, string>();
            foreach (KeyValuePair<int, int?> pair in dic)
            {
                if (pair.Value != null)
                {
                    tmp.Add("cell_" + pair.Key, "tile_" + (pair.Value + 1));
                }
            }
            return tmp;
        }

        public static Dictionary<string, string> FilterUnused(this Dictionary<int, string> dic, Dictionary<int, int?> layer0, Dictionary<int, int?> layer1)
        {
            Dictionary<string, string> tmp = new Dictionary<string, string>();
            foreach (KeyValuePair<int, string> pair in dic)
            {
                tmp.Add("tile_" + (pair.Key), pair.Value);
            }

            return tmp;
        }
    }
}
